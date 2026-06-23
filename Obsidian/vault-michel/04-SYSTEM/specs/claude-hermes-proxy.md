---
title: "Claude-Hermes — Proxy Local OpenAI-compat"
type: spec
status: histórico
created: 2026-06-09
restored: 2026-06-22
note: "Movido de 04-SYSTEM/agents/core/ — não é agente, é spec de infra. Recuperado de commit 4c97666 após deleção indevida em fa1a3e0 (plano-acoes-revisao-2026-06-21 item 1)."
---

# Claude-Hermes  
  
# Prompt: Construir proxy local que reexpõe Claude Code CLI como API OpenAI-compat
  
## Goal  
  
Construir um proxy HTTP local em `127.0.0.1:8080` que aceita requests no formato OpenAI Chat Completions (`/v1/chat/completions`, `/v1/models`) e roteia para o `claude` CLI (Claude Code) via subprocess. Resultado: qualquer cliente OpenAI-compat (hermes, Cursor, scripts, dashboards) pode usar o Claude Opus 4.7 ou Sonnet 4.6 da assinatura Claude Code do user, **sem precisar de ANTHROPIC_API_KEY** e sem custo adicional além da assinatura.  
  
## Premises (validar antes de começar)  
  
1. `claude` CLI instalado em `~/.config/npm-global/bin/claude` (ou similar — confirmar com `which claude`). Versão do Claude Code suporta `--input-format stream-json`.  
2. Usuário autenticado no `claude` (OAuth/keychain) — testar com `claude -p --model opus "oi"` deve retornar texto.  
3. `python3` ≥3.11 disponível.  
4. Porta 8080 livre (`lsof -ti:8080` deve retornar vazio).  
5. Cliente que vai consumir (ex: hermes CLI) já existe.  
  
## Arquitetura  
  
```  
cliente OpenAI-compat (hermes -z, curl, etc)  
    │  HTTP POST /v1/chat/completions  
    ▼  
proxy FastAPI (porta 8080)  
    │  envelope JSON via stdin  
    ▼  
daemon claude (subprocess persistente, modo stream-json)  
    │  OAuth/keychain  
    ▼  
Anthropic API (Opus 4.7 ou Sonnet 4.6)  
```  
  
**Por que daemon e não subprocess oneshot por request:** cold start do `claude` CLI é ~5-7s. Daemon mantém o processo vivo e cache hot — latência cai pra ~1.7-2s warm. Com cache reuse, do 2º turno em diante o `cache_creation_input_tokens` despenca de ~30k pra ~22 (economia significativa de rate limit da assinatura).  
  
## Layout de arquivos a criar  
  
```  
claude_web_proxy/  
├── server.py  
├── requirements.txt  
├── start.sh  
├── .gitignore  
├── README.md  
└── prompts/  
    └── voice.example.md  
```  
  
## Decisões de configuração  
  
| Decisão | Escolha | Justificativa |  
|---|---|---|  
| Web framework | FastAPI + uvicorn | OpenAI-compat trivial; SSE nativo via StreamingResponse |  
| Modelo default | Sonnet 4.6 | ~40% mais rápido que Opus 4.7 em cold (~4s vs ~7s); custo equivalente -58% no rate limit; qualidade equivalente em escrita estruturada e copywriting |  
| Effort | `max` | Qualidade prioritária (user pediu) |  
| Voice persona | `--append-system-prompt <file>` no spawn | System prompt inline OpenAI-compat (`role: system` no body) é **silenciosamente ignorado** pelo Claude Code. Único caminho confiável é `--append-system-prompt` no spawn — voz fixa por daemon, troca = restart |  
| Cwd do subprocess | `/tmp` | Sandbox razoável; evita Claude descobrir CLAUDE.md/skills do projeto chamador |  
| Concorrência | Lock asyncio único | Daemon claude não suporta requests concorrentes; requests serializadas. Pra paralelismo real, evoluir pra pool depois |  
  
## Arquivo: `server.py`  
  
```python  
import asyncio  
import json  
import os  
import time  
import uuid  
from contextlib import asynccontextmanager  
from typing import Any, AsyncGenerator  
  
from fastapi import FastAPI, Request  
from fastapi.responses import JSONResponse, StreamingResponse  
  
MODEL_ID = "anthropic/claude-opus-4.7"  
  
CLAUDE_BIN = os.environ.get("CLAUDE_BIN", "/Users/jeff/.config/npm-global/bin/claude")  
CLAUDE_MODEL = os.environ.get("CLAUDE_UPSTREAM_MODEL", "opus")  
CLAUDE_TIMEOUT = float(os.environ.get("CLAUDE_TIMEOUT", "120"))  
CLAUDE_CWD = os.environ.get("CLAUDE_CWD", "/tmp")  
CLAUDE_WARMUP = os.environ.get("CLAUDE_WARMUP", "1") == "1"  
APPEND_SYSTEM_FILE = os.environ.get("HERMES_APPEND_SYSTEM_PROMPT_FILE", "")  
  
  
def _load_append_system() -> str:  
    if not APPEND_SYSTEM_FILE:  
        return ""  
    try:  
        with open(APPEND_SYSTEM_FILE, "r", encoding="utf-8") as f:  
            return f.read().strip()  
    except OSError:  
        return ""  
  
  
class ClaudeDaemon:  
    def __init__(self) -> None:  
        self.proc: asyncio.subprocess.Process | None = None  
        self.lock = asyncio.Lock()  
  
    async def _spawn(self) -> None:  
        args = [  
            CLAUDE_BIN,  
            "--input-format", "stream-json",  
            "--output-format", "stream-json",  
            "--verbose",  
            "--model", CLAUDE_MODEL,  
            "--effort", "max",  
            "--no-session-persistence",  
            "--permission-mode", "bypassPermissions",  
            "--tools", "",  
            "--disable-slash-commands",  
            "--exclude-dynamic-system-prompt-sections",  
        ]  
        appended = _load_append_system()  
        if appended:  
            args.extend(["--append-system-prompt", appended])  
        self.proc = await asyncio.create_subprocess_exec(  
            *args,  
            stdin=asyncio.subprocess.PIPE,  
            stdout=asyncio.subprocess.PIPE,  
            stderr=asyncio.subprocess.PIPE,  
            cwd=CLAUDE_CWD,  
        )  
  
    async def warmup(self) -> None:  
        async for _ in self.query_stream("ok"):  
            pass  
  
    async def query_stream(self, prompt: str) -> AsyncGenerator[tuple[str, bool], None]:  
        async with self.lock:  
            if self.proc is None or self.proc.returncode is not None:  
                await self._spawn()  
            assert self.proc and self.proc.stdin and self.proc.stdout  
  
            envelope = json.dumps(  
                {"type": "user", "message": {"role": "user", "content": prompt}}  
            )  
            self.proc.stdin.write((envelope + "\n").encode())  
            await self.proc.stdin.drain()  
  
            accumulated = ""  
            deadline = asyncio.get_event_loop().time() + CLAUDE_TIMEOUT  
            while True:  
                remaining = deadline - asyncio.get_event_loop().time()  
                if remaining <= 0:  
                    await self._kill()  
                    yield (f"[upstream timeout after {CLAUDE_TIMEOUT}s]", True)  
                    return  
                try:  
                    line = await asyncio.wait_for(  
                        self.proc.stdout.readline(), timeout=remaining  
                    )  
                except asyncio.TimeoutError:  
                    await self._kill()  
                    yield (f"[upstream timeout after {CLAUDE_TIMEOUT}s]", True)  
                    return  
                if not line:  
                    yield ("[upstream closed stdout]", True)  
                    return  
                try:  
                    obj = json.loads(line)  
                except json.JSONDecodeError:  
                    continue  
  
                obj_type = obj.get("type")  
                if obj_type == "assistant":  
                    text = _extract_text(obj.get("message", {}).get("content", []))  
                    if len(text) > len(accumulated):  
                        delta = text[len(accumulated):]  
                        accumulated = text  
                        yield (delta, False)  
                elif obj_type == "result":  
                    final = obj.get("result", "")  
                    if len(final) > len(accumulated):  
                        yield (final[len(accumulated):], False)  
                    yield ("", True)  
                    return  
  
    async def query(self, prompt: str) -> str:  
        parts: list[str] = []  
        async for delta, _final in self.query_stream(prompt):  
            if delta:  
                parts.append(delta)  
        return "".join(parts)  
  
    async def _kill(self) -> None:  
        if self.proc and self.proc.returncode is None:  
            self.proc.kill()  
            await self.proc.wait()  
        self.proc = None  
  
    async def shutdown(self) -> None:  
        async with self.lock:  
            if self.proc and self.proc.returncode is None:  
                self.proc.terminate()  
                try:  
                    await asyncio.wait_for(self.proc.wait(), timeout=5)  
                except asyncio.TimeoutError:  
                    self.proc.kill()  
                    await self.proc.wait()  
            self.proc = None  
  
  
def _extract_text(content_blocks: list[Any]) -> str:  
    return "".join(  
        b.get("text", "")  
        for b in content_blocks  
        if isinstance(b, dict) and b.get("type") == "text"  
    )  
  
  
daemon = ClaudeDaemon()  
  
  
@asynccontextmanager  
async def lifespan(_app: FastAPI) -> AsyncGenerator[None, None]:  
    await daemon._spawn()  
    if CLAUDE_WARMUP:  
        try:  
            await daemon.warmup()  
        except Exception:  
            pass  
    try:  
        yield  
    finally:  
        await daemon.shutdown()  
  
  
app = FastAPI(title="claude_web proxy", version="0.4.0", lifespan=lifespan)  
  
  
@app.get("/v1/models")  
async def list_models() -> dict[str, Any]:  
    return {  
        "object": "list",  
        "data": [{  
            "id": MODEL_ID, "object": "model",  
            "created": int(time.time()), "owned_by": "claude_web",  
        }],  
    }  
  
  
def _flatten_content(content: Any) -> str:  
    if isinstance(content, str):  
        return content  
    if isinstance(content, list):  
        return "".join(  
            p.get("text", "") for p in content  
            if isinstance(p, dict) and p.get("type") in (None, "text")  
        )  
    return ""  
  
  
def _build_prompt(messages: list[dict[str, Any]]) -> str:  
    system_parts: list[str] = []  
    for msg in messages:  
        if msg.get("role") == "system":  
            text = _flatten_content(msg.get("content"))  
            if text.strip():  
                system_parts.append(text.strip())  
  
    user_text = ""  
    for msg in reversed(messages):  
        if msg.get("role") == "user":  
            user_text = _flatten_content(msg.get("content"))  
            break  
  
    if system_parts:  
        system_text = "\n\n".join(system_parts)  
        return (  
            f"<system_instructions>\n{system_text}\n</system_instructions>\n\n"  
            f"{user_text}"  
        )  
    return user_text  
  
  
@app.post("/v1/chat/completions")  
async def chat_completions(request: Request) -> Any:  
    body = await request.json()  
    messages = body.get("messages", [])  
    stream = bool(body.get("stream", False))  
    model = body.get("model", MODEL_ID)  
  
    prompt = _build_prompt(messages)  
    completion_id = f"chatcmpl-{uuid.uuid4().hex[:24]}"  
    created = int(time.time())  
  
    if not stream:  
        reply = await daemon.query(prompt)  
        return JSONResponse({  
            "id": completion_id, "object": "chat.completion",  
            "created": created, "model": model,  
            "choices": [{  
                "index": 0,  
                "message": {"role": "assistant", "content": reply},  
                "finish_reason": "stop",  
            }],  
            "usage": {  
                "prompt_tokens": len(prompt.split()),  
                "completion_tokens": len(reply.split()),  
                "total_tokens": len(prompt.split()) + len(reply.split()),  
            },  
        })  
  
    async def event_stream() -> AsyncGenerator[bytes, None]:  
        def _chunk(delta: dict[str, Any], finish: str | None = None) -> bytes:  
            payload = {  
                "id": completion_id, "object": "chat.completion.chunk",  
                "created": created, "model": model,  
                "choices": [{"index": 0, "delta": delta, "finish_reason": finish}],  
            }  
            return f"data: {json.dumps(payload)}\n\n".encode()  
  
        yield _chunk({"role": "assistant"})  
        async for delta, is_final in daemon.query_stream(prompt):  
            if delta and not is_final:  
                yield _chunk({"content": delta})  
        yield _chunk({}, finish="stop")  
        yield b"data: [DONE]\n\n"  
  
    return StreamingResponse(event_stream(), media_type="text/event-stream")  
  
  
@app.get("/healthz")  
async def healthz() -> dict[str, str]:  
    alive = daemon.proc is not None and daemon.proc.returncode is None  
    return {  
        "status": "ok" if alive else "degraded",  
        "daemon": "alive" if alive else "dead",  
    }  
```  
  
## Arquivo: `requirements.txt`  
```  
fastapi>=0.110  
uvicorn[standard]>=0.27  
```  
  
## Arquivo: `start.sh` (chmod +x)  
```bash  
#!/usr/bin/env bash  
set -euo pipefail  
cd "$(dirname "$0")"  
  
export CLAUDE_UPSTREAM_MODEL="${CLAUDE_UPSTREAM_MODEL:-sonnet}"  
export HERMES_APPEND_SYSTEM_PROMPT_FILE="${HERMES_APPEND_SYSTEM_PROMPT_FILE:-}"  
  
if [ ! -d ".venv" ]; then  
  python3 -m venv .venv  
  ./.venv/bin/pip install --quiet --upgrade pip  
  ./.venv/bin/pip install --quiet -r requirements.txt  
fi  
  
exec ./.venv/bin/uvicorn server:app \  
  --host 127.0.0.1 --port 8080 --log-level info  
```  
  
## Arquivo: `.gitignore`  
```  
.venv/  
__pycache__/  
*.pyc  
```  
  
## Arquivo: `prompts/voice.example.md`  
Placeholder com regras de voz/persona. User substitui pelo guia real (style guide de marca, regras de output, etc).  
  
## Smoke tests (rodar em ordem)  
  
```bash  
# 1. Subir o servidor  
./start.sh &  
until curl -sf http://127.0.0.1:8080/healthz | grep -q '"status":"ok"'; do sleep 1; done  
  
# 2. Validar /v1/models  
curl -s http://127.0.0.1:8080/v1/models | python3 -m json.tool  
  
# 3. Validar chat non-streaming (espera resposta real do modelo)  
curl -s http://127.0.0.1:8080/v1/chat/completions \  
  -H 'Content-Type: application/json' \  
  -d '{"model":"anthropic/claude-sonnet-4.6","messages":[{"role":"user","content":"diga apenas: ok"}]}' \  
  | python3 -m json.tool  
  
# 4. Validar streaming SSE  
curl -N -s http://127.0.0.1:8080/v1/chat/completions \  
  -H 'Content-Type: application/json' \  
  -d '{"model":"anthropic/claude-sonnet-4.6","messages":[{"role":"user","content":"diga: stream ok"}],"stream":true}'  
  
# 5. Validar via cliente OpenAI-compat (exemplo: hermes)  
LM_BASE_URL=http://127.0.0.1:8080/v1 LM_API_KEY=stub \  
  hermes -z "diga: integração ok" --provider lmstudio -m anthropic/claude-sonnet-4.6  
```  
  
Cada smoke test deve retornar resposta gerada pelo modelo real. Se algum falhar, **NÃO continuar** — debugar antes.  
  
## Variáveis de ambiente  
  
| Var | Default | Função |  
|---|---|---|  
| `CLAUDE_BIN` | `/Users/jeff/.config/npm-global/bin/claude` | Caminho do binário claude |  
| `CLAUDE_UPSTREAM_MODEL` | `sonnet` (no start.sh) | `sonnet`, `opus`, `claude-sonnet-4-6`, etc |  
| `CLAUDE_TIMEOUT` | `120` | Timeout em segundos por request |  
| `CLAUDE_CWD` | `/tmp` | Diretório onde o subprocess roda |  
| `CLAUDE_WARMUP` | `1` | Se `1`, lifespan envia ping de warmup |  
| `HERMES_APPEND_SYSTEM_PROMPT_FILE` | `""` | Path pra arquivo .md com voz/persona |  
  
## Gotchas críticos descobertos durante desenvolvimento (não pular)  
  
1. **System prompt inline OpenAI-compat (`role: system` no body) é silenciosamente DESCARTADO pelo Claude Code.** Tag `<system_instructions>` em user message tem peso menor que system prompt nativo. Único caminho confiável pra voz custom é `--append-system-prompt` no spawn (fixo por processo).  
  
2. **Envelope `{"type":"system",...}` no stream-json input também é ignorado.** Não tente esse caminho.  
  
3. **`--include-partial-messages` só funciona com `-p` (oneshot)** — incompatível com modo daemon persistente. Streaming "real" token-by-token não rola; o daemon emite o texto inteiro em 1 chunk de `assistant`. TTFB ainda fica baixo (~3ms) porque o proxy emite `{role:"assistant"}` antes do daemon retornar, mas o conteúdo não pinga progressivamente.  
  
4. **`--bare` exige `ANTHROPIC_API_KEY`.** Não funciona com OAuth/keychain (vai falhar com "Not logged in"). Não use se objetivo é evitar API key.  
  
5. **Cliente como hermes não tem provider `claude_web` registrado.** Reaproveitar slot `lmstudio` (ou similar OpenAI-compat-com-base-URL-customizável) com `LM_BASE_URL=http://127.0.0.1:8080/v1` + `LM_API_KEY=stub`.  
  
6. **Validação binária via `test -s`, não Read tool** — convenção do framework opensquad e padrão recomendado: `test -s arquivo.json` retorna 0 se existe e tem tamanho >0; binário, não pode ser alucinado por LLM.  
  
7. **Daemon serializa requests via lock asyncio.** Sem paralelismo real. Pool homogêneo de N daemons ajuda em batch concorrente — mas não acelera 1 request, e todos compartilham mesmo rate limit Anthropic da assinatura. Implementar pool só quando virar gargalo de bursty workload.  
  
8. **Histórico acumula no daemon.** Cada request adiciona ao contexto interno. Pra reset, restart o daemon (ou implemente recycle a cada N turnos).  
  
## Latências esperadas (após warmup)  
  
| Cenário | Latência |  
|---|---|  
| Curl direto, warm, prompt curto | ~1.7-2.2s |  
| Via cliente OpenAI-compat (ex: hermes) | +1.5-3s (overhead do cliente) |  
| 1ª request sem warmup | ~3-5s (cold daemon) |  
| Cache_creation_input_tokens cold | ~27-39k tokens |  
| Cache_creation_input_tokens warm (2º+) | ~22 tokens |  
  
## Custo  
  
Zero $ direto enquanto OAuth ativo (assinatura Claude Code). O campo `total_cost_usd` que aparece no output stream-json é **valor calculado equivalente "se fosse API key"**, não cobrança real. Implicação: cache reuse não economiza $ direto, mas **economiza slot do rate limit de 5h da assinatura** (cache reads pesam menos).  
  
## Validação final  
  
Ao terminar, confirme:  
- [ ] `curl /healthz` retorna `{"status":"ok","daemon":"alive"}`  
- [ ] `curl /v1/chat/completions` (non-stream) retorna texto real do modelo  
- [ ] `curl /v1/chat/completions` (stream:true) retorna SSE com `data:` chunks + `[DONE]`  
- [ ] Cliente OpenAI-compat externo consegue invocar  
- [ ] Se `HERMES_APPEND_SYSTEM_PROMPT_FILE` setado, voz aparece no output  
- [ ] Latência warm ≤2.5s pra prompt curto  
- [ ] Restart `lsof -ti:8080 | xargs kill && ./start.sh` funciona limpo  
  
