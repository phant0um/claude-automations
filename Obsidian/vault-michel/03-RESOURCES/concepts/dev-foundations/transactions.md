---
title: "Transações de Banco"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, database]
status: developing
---

# Transações de Banco

Garantir que um conjunto de operações execute tudo ou nada — o mecanismo que impede que sua conta bancária perca dinheiro no ar.

## O que é

Uma transação de banco de dados é uma unidade lógica de trabalho composta por uma ou mais operações SQL que devem ser executadas de forma atômica. As propriedades que garantem a integridade são resumidas pelo acrônimo **ACID**:

- **Atomicidade:** tudo ou nada. Se uma operação falha, todas as anteriores da transação são desfeitas (rollback). Não existe "metade de uma transferência".
- **Consistência:** a transação leva o banco de um estado válido a outro estado válido, respeitando todas as restrições (chaves estrangeiras, constraints, triggers).
- **Isolamento:** transações concorrentes não se interferem. O grau de isolamento é configurável (ver níveis abaixo).
- **Durabilidade:** após o `COMMIT`, as mudanças persistem mesmo se o servidor cair logo em seguida — garantido por write-ahead log (WAL).

**Níveis de isolamento** (do mais fraco ao mais forte):
1. **Read Uncommitted** — lê dados não commitados (dirty read) — raramente usado
2. **Read Committed** — lê apenas dados commitados (padrão em Oracle/PostgreSQL)
3. **Repeatable Read** — garante que leituras repetidas na mesma transação retornam o mesmo valor (padrão MySQL/InnoDB)
4. **Serializable** — máxima proteção, equivale a executar transações em série — menor concorrência

## Como funciona

```java
// JDBC — controle manual de transação
Connection conn = DriverManager.getConnection(url, user, pass);
conn.setAutoCommit(false); // desliga auto-commit

try {
    // Transferência: debitar conta A, creditar conta B
    PreparedStatement debitar = conn.prepareStatement(
        "UPDATE conta SET saldo = saldo - ? WHERE id = ?");
    debitar.setDouble(1, 500.0);
    debitar.setInt(2, contaOrigem);
    debitar.executeUpdate();

    PreparedStatement creditar = conn.prepareStatement(
        "UPDATE conta SET saldo = saldo + ? WHERE id = ?");
    creditar.setDouble(1, 500.0);
    creditar.setInt(2, contaDestino);
    creditar.executeUpdate();

    conn.commit(); // tudo OK — persiste
} catch (SQLException e) {
    conn.rollback(); // qualquer erro — desfaz tudo
    throw e;
} finally {
    conn.setAutoCommit(true);
    conn.close();
}
```

**Deadlock** ocorre quando duas transações esperam uma pela outra para liberar um lock — o banco detecta e mata uma delas com rollback automático.

## Por que importa

Qualquer sistema financeiro, e-commerce ou ERP depende de transações corretas. Na FIAP Fase 2 (JDBC + banco), você implementa transações manualmente. Com Spring/JPA, usa `@Transactional` (que encapsula o mesmo mecanismo). Em concursos de banco de dados (CESPE, FCC), ACID e níveis de isolamento são tópicos recorrentes.

## Exemplo

Sem transação: debita conta A (OK), servidor cai, conta B não recebe — R$500 evaporaram.
Com transação: rollback automático — saldo de A volta ao valor original.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/dao-pattern]]
- [[03-RESOURCES/concepts/mvc-architecture]]
