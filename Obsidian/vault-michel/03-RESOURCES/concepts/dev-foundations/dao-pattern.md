---
title: "DAO Pattern"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, java, database]
status: developing
---

# DAO Pattern

Isolar todo código de acesso ao banco em um lugar só — para que o resto da aplicação nem saiba se o dado vem de SQL, arquivo ou API.

## O que é

DAO (Data Access Object) é um padrão de projeto que separa a lógica de persistência do resto da aplicação. Toda operação de banco de dados (SELECT, INSERT, UPDATE, DELETE) fica encapsulada dentro de classes DAO — o Service ou Controller nunca escreve SQL diretamente.

A distinção DAO vs Repository é sutil mas importante: DAO pensa em termos de **tabelas** (uma DAO por tabela, operações CRUD diretas), enquanto Repository pensa em termos de **domínio** (um repositório por agregado, pode envolver múltiplas tabelas). Em projetos FIAP com JDBC puro, você usará DAO. Em projetos com Spring Data JPA, verá `@Repository`.

A interface DAO define o contrato; a implementação concreta cuida do JDBC. Isso permite trocar a implementação (de Oracle para PostgreSQL, ou para mock em testes) sem tocar no código de negócio.

## Como funciona

```java
// Interface — o contrato
public interface ProdutoDAO {
    void salvar(Produto p);
    Produto buscarPorId(int id);
    List<Produto> listarTodos();
    void atualizar(Produto p);
    void deletar(int id);
}

// Implementação com JDBC
public class ProdutoDAOImpl implements ProdutoDAO {
    private Connection conn;

    public ProdutoDAOImpl(Connection conn) { this.conn = conn; }

    @Override
    public void salvar(Produto p) {
        String sql = "INSERT INTO produto (nome, preco) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPreco());
            ps.executeUpdate();
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
    // demais métodos...
}
```

## Por que importa

Na FIAP Fase 2 (Java Web + JDBC), o padrão DAO é ensinado e cobrado nos projetos. Entender DAO é o passo antes de Spring Data JPA — quando você finalmente usa `@Repository` e `save()`, sabe exatamente o que acontece por baixo. Em entrevistas de estágio Java, "explique o padrão DAO" é pergunta clássica.

## Exemplo

Sem DAO: SQL espalhado no Controller, Service e até nas Views — um erro de coluna quebra 10 arquivos.
Com DAO: muda a query em um único lugar; o resto da aplicação não percebe.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/mvc-architecture]]
- [[03-RESOURCES/concepts/transactions]]
- [[03-RESOURCES/concepts/encapsulamento]]
