---
title: "MVC Architecture"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations, architecture]
status: developing
---

# MVC Architecture

Separar dados, apresentação e controle — o padrão que organiza quase toda aplicação web que você já usou.

## O que é

MVC (Model-View-Controller) é um padrão arquitetural que divide a aplicação em três camadas com responsabilidades bem definidas. O **Model** cuida dos dados e da lógica de negócio (entidades, regras, acesso ao banco). A **View** é responsável pela apresentação — HTML, JSP, Thymeleaf, ou qualquer template que o usuário vê. O **Controller** é o mediador: recebe a requisição, aciona o Model, e decide qual View retornar.

Essa separação resolve o problema do "código espaguete" onde SQL, HTML e lógica de negócio estão todos misturados no mesmo arquivo. Com MVC, cada camada tem uma única responsabilidade e pode evoluir de forma independente — você pode trocar a View (de JSP para React) sem tocar no Model.

Em Java, o MVC aparece primeiro via Servlets puros (Fase 2 FIAP) e depois com Spring MVC, onde `@Controller`, `@Service` e `@Repository` mapeiam diretamente as três camadas.

## Como funciona

Fluxo de uma requisição HTTP típica:

```
Cliente → HTTP Request
  → Controller (recebe, valida parâmetros)
      → Service (executa lógica de negócio)
          → DAO/Repository (acessa banco)
      ← retorna dados
  → Controller escolhe View
      → View renderiza HTML com os dados
← HTTP Response
```

Em Spring MVC:
```java
@Controller
public class ProdutoController {
    @Autowired ProdutoService service;

    @GetMapping("/produtos")
    public String listar(Model model) {
        model.addAttribute("produtos", service.listarTodos());
        return "produtos/lista"; // nome do template
    }
}
```

## Por que importa

MVC é o padrão dominante em aplicações web Java — Spring MVC, Jakarta EE, Struts são todos MVC. Na FIAP, é exigido explicitamente na Fase 2 (Java Web) e nas fases de Fintech. Em concursos, aparece em questões de engenharia de software e arquitetura de sistemas. Entender MVC é também a base para REST APIs (`@RestController` + JSON no lugar da View).

## Exemplo

Sem MVC: um Servlet com 300 linhas misturando `SELECT SQL`, `out.println("<table>")` e validação de negócio.
Com MVC: Controller com 15 linhas, Service com regras testáveis, View com template limpo.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/dao-pattern]]
- [[03-RESOURCES/concepts/engenharia-de-software]]
- [[03-RESOURCES/concepts/user-stories]]
