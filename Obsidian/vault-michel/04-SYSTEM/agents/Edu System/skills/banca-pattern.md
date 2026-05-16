---
title: "Banca Pattern"
type: skill
used-by: [banca, mestre]
version: 1.0.0
---

# Skill: Banca Pattern

Identificar a banca informada e aplicar o padrão de cobrança correto antes de qualquer análise de questão.

## Padrões por Banca

### CESPE / CEBRASPE

**Formato:** Certo ou Errado (C/E). Uma afirmativa por item.

**Padrão de cobrança:**
- Buscar **modificadores absolutos** — se presentes, a afirmativa tende a ser ERRADA
  - Exemplos: `somente`, `sempre`, `necessariamente`, `em regra`, `exclusivamente`, `apenas`, `unicamente`, `inevitavelmente`
- Itens com **"e"** ligando dois conceitos: se um estiver errado, o item inteiro cai
- **Negativa de exceção:** "Não há exceção para X" — verificar se a lei prevê alguma
- **Troca de palavras-chave:** "pode" por "deve", "facultativo" por "obrigatório"
- **Inversão causa/efeito:** A causa B → virar que B causa A
- **Extrapolação de conceito:** afirmar algo que a lei não diz explicitamente

**Checklist CESPE ao analisar item:**
1. Tem modificador absoluto? → alta chance de ERRADO
2. Tem "e" ligando dois conceitos? → verificar ambos
3. Tem negação de exceção? → procurar a exceção
4. Troca de termo técnico? → comparar com lei
5. Afirma algo que a lei não diz? → ERRADO por extrapolação

---

### FCC (Fundação Carlos Chagas)

**Formato:** Múltipla escolha (5 alternativas A-E). Questões frequentemente de completar lacunas.

**Padrão de cobrança:**
- **Letra de lei:** cobrar artigo, parágrafo, inciso literalmente — não interpretação doutrinária
- **Alternativas com palavras muito parecidas:** distratores semânticos (trocar "pode" por "deve", "obrigatório" por "facultativo")
- **Completar lacunas:** usar o texto da lei como gabarito — não parafrasear
- **Pegadinhas de nomenclatura:** trocar nome técnico por sinônimo não previsto em lei
- **Itens "EXCETO":** pedir a exceção — cuidado com dupla negação

**Checklist FCC:**
1. Questão de lacuna? → buscar texto literal da lei
2. Tem alternativas muito similares? → identificar a diferença semântica crítica
3. Tem "EXCETO" ou "NÃO"? → listar o que é correto e excluir
4. Cobrando nomenclatura? → verificar o termo exato da lei

---

### FGV (Fundação Getulio Vargas)

**Formato:** Múltipla escolha. Questões mais longas com casos práticos.

**Padrão de cobrança:**
- **Interpretação sistemática:** combinar 2+ normas/artigos para chegar à resposta
- **Casos práticos com múltiplas variáveis:** enunciado longo com situação concreta — isolar cada variável
- **Hierarquia normativa:** saber o que prevalece quando normas conflitam
- **Princípios gerais:** cobrar aplicação prática de princípio, não só definição

**Checklist FGV:**
1. Questão tem situação prática? → identificar qual regra se aplica ao caso
2. Tem conflito de normas? → aplicar hierarquia normativa
3. Pede princípio? → não é definição — é aplicação

---

### VUNESP

**Formato:** Múltipla escolha. Questões mais diretas, base doutrinária clássica.

**Padrão de cobrança:**
- **Literalidade de lei:** cobrar artigos específicos com frequência
- **Doutrina clássica:** Hely Meirelles, Di Pietro, Celso Antônio — citações frequentes
- **Questões diretas:** enunciado curto, alternativa mais direta tende a ser correta
- **Atenção a detalhes:** prazos, percentuais, números específicos

**Checklist VUNESP:**
1. Cita doutrinador? → conhecer posição dos clássicos
2. Tem números/prazos? → verificar artigo específico
3. Alternativa mais simples e direta? → considerar fortemente

---

### IBFC

**Formato:** Múltipla escolha. Mix de lei + jurisprudência.

**Padrão de cobrança:**
- **Combinação lei + jurisprudência:** cobrar Súmulas STF/STJ junto com artigos
- **Jurisprudência consolidada:** Súmulas com números específicos
- **Questões de atualidade:** normas recentes e alterações legislativas
- **Interpretação extensiva:** menos literal que FCC, mais que CESPE

**Checklist IBFC:**
1. Cita jurisprudência? → conhecer Súmulas relevantes da área
2. Tema recente? → verificar alterações legislativas recentes
3. Interpretação extensiva ou restritiva? → analisar contexto

---

## Armadilhas Universais (todas as bancas)

| Armadilha | Como identificar |
|-----------|-----------------|
| Inversão de termos | "pode" ↔ "deve", "facultativo" ↔ "obrigatório" |
| Generalização indevida | "sempre", "todos", "em qualquer caso" |
| Exceção ignorada | "não há exceção" quando a lei prevê uma |
| Mistura de conceitos | juntar dois institutos distintos na mesma afirmativa |
| Prazo trocado | 15 dias → 30 dias, 5 anos → 3 anos |
| Artigo trocado | mesmo conteúdo, artigo errado |
| Falsa autoridade | "segundo a doutrina" sem especificar |
