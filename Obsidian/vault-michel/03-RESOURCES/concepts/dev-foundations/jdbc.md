---
title: JDBC — Java Database Connectivity
type: concept
status: developing
tags: [java, banco-de-dados, fiap, fase-6]
created: 2026-04-14
updated: 2026-05-19
---

# JDBC — Java Database Connectivity

API Java para conectar e executar operações em bancos de dados relacionais. Permite que programas Java se comuniquem com Oracle, MySQL, PostgreSQL, etc.

## Fluxo básico

```java
// 1. Carregar driver
Class.forName("oracle.jdbc.driver.OracleDriver");

// 2. Obter conexão
Connection conn = DriverManager.getConnection(
    "jdbc:oracle:thin:@localhost:1521:xe", "user", "senha"
);

// 3. Criar statement
PreparedStatement stmt = conn.prepareStatement(
    "SELECT * FROM conta WHERE cliente_id = ?"
);
stmt.setInt(1, clienteId);

// 4. Executar e processar resultado
ResultSet rs = stmt.executeQuery();
while (rs.next()) {
    System.out.println(rs.getString("nome"));
}

// 5. Fechar recursos
rs.close(); stmt.close(); conn.close();
```

## Classes principais

| Classe/Interface | Função |
|---|---|
| `DriverManager` | Gerencia drivers e conexões |
| `Connection` | Representa uma conexão ativa |
| `PreparedStatement` | Query parametrizada (previne SQL injection) |
| `ResultSet` | Resultado de uma consulta |

## Ver também

- [[03-RESOURCES/concepts/dev-foundations/sql|SQL]]
- [[03-RESOURCES/entities/Java|Java]]
- [[03-RESOURCES/entities/Oracle-SQL|Oracle SQL]]
- [[02-AREAS/fiap/fase-6/fase-6-index|Fase 6 — Model]]
