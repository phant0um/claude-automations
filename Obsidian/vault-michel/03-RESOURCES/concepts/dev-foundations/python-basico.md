---
title: "Python Básico"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, python]
status: developing
---

# Python Básico

A linguagem mais usada em IA, data science e automação — e que contrasta com Java em quase tudo que você aprendeu até agora.

## O que é

Python é uma linguagem interpretada, de tipagem dinâmica e forte, com sintaxe minimalista — sem chaves, sem ponto-e-vírgula obrigatório, sem declaração de tipos. A indentação (espaços/tabs) **é** a sintaxe: blocos são definidos pelo recuo, não por `{}`. Isso força código legível mas causa erros sutis se você misturar tabs e espaços.

As principais diferenças em relação ao Java: variáveis não precisam de tipo declarado (`x = 10` funciona, e depois `x = "texto"` também), funções são definidas com `def`, e tudo é objeto. Não existe `int` primitivo — `10` já é um objeto `int`.

Módulos são a unidade de organização: qualquer arquivo `.py` é um módulo, e você importa com `import math` ou `from os import path`. O ecossistema de pacotes (PyPI) tem bibliotecas para tudo: `numpy`/`pandas` para dados, `requests` para HTTP, `flask`/`fastapi` para web.

## Como funciona

```python
# Tipagem dinâmica — sem declaração
nome = "Michel"
idade = 22
ativo = True

# Listas, dicts e tuplas
nomes = ["Ana", "Bob", "Carol"]
pessoa = {"nome": "Michel", "idade": 22}  # dict = HashMap
ponto = (3, 4)  # tupla — imutável

# List comprehension — idiomático em Python
pares = [x for x in range(10) if x % 2 == 0]
# [0, 2, 4, 6, 8]

cuadrados = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# Funções
def saudacao(nome, saudacao="Olá"):
    return f"{saudacao}, {nome}!"

# Importando módulos
import math
print(math.sqrt(16))  # 4.0
```

## Por que importa

Python é a lingua franca de IA/ML — toda biblioteca relevante (TensorFlow, PyTorch, scikit-learn, LangChain) é Python. Como desenvolvedor em 2026, você inevitavelmente escreverá scripts de automação, notebooks de análise, ou agentes de IA em Python. Na FIAP, Python aparece em disciplinas de IA e Data Science nas fases avançadas. Para concursos federais de TI, Python é cada vez mais cobrado junto com Java.

## Exemplo

Java: `for (String s : lista) { if (s.length() > 3) result.add(s.toUpperCase()); }`
Python: `[s.upper() for s in lista if len(s) > 3]` — uma linha, mesmo resultado.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/colecoes-java]]
- [[03-RESOURCES/concepts/algoritmo]]
