---
title: "How to Design a Backend That Handles 1 Million Users Without Breaking"
type: source
source: Clippings/How to Design a Backend That Handles 1 Million Users Without Breaking.md
created: 2026-05-17
ingested: 2026-05-17
tags: [dev, architecture, backend, scaling]
triagem_score: 7
---

## Tese central
Backend para 1M usuários exige decisões de arquitetura cedo: stateless services, cache em camadas, fila pra writes, sharding ou read replicas — não otimização tardia.

## Key insights
- Stateless = horizontal scaling barato; sticky session é debt
- Cache hierárquico (CDN → app cache → DB cache) reduz DB load 100x+
- Fila desacopla writes pesados — backpressure controlado vs falhar em hora de pico
- Relevante para FIAP Fase 7 (REST + Spring Boot + Next.js): pensar em escala desde cedo

## Arquitetura em Camadas: Do Zero a 1M Usuários

### Fase 1: 0-10k usuários (Monólito simples)

```
Client → Load Balancer → App Server → PostgreSQL
```

Nesta fase, tudo pode ser um processo. O erro crítico é premature optimization: adicionar Kafka, Redis e sharding antes de ter 1000 usuários ativos. O foco deve ser no produto, não na infra.

O que configurar desde o início:
- **Connection pooling** (pgBouncer ou HikariCP para Spring Boot): sem isso, 100 usuários simultâneos esgotam conexões DB
- **Health checks**: load balancer precisa saber quando remover instâncias doentes
- **Structured logging**: JSON logs desde o início facilitam debugging em escala

### Fase 2: 10k-100k usuários (Stateless + Cache)

A primeira crise de escala tipicamente não é o banco — é a sessão. Se o app usa `HttpSession` ou similar, cada request precisa ir ao mesmo servidor (sticky session) ou ao banco (session storage). A correção:

**Tornar o serviço stateless:**
```java
// Antes: sessão no servidor
HttpSession session = request.getSession();
session.setAttribute("userId", userId);

// Depois: JWT stateless
String token = jwtUtil.generateToken(userId);
response.setHeader("Authorization", "Bearer " + token);
```

**Cache hierárquico:**
```
Client → CDN (assets estáticos, TTL 24h)
       → Redis (dados de sessão/user, TTL 30min)
       → App Server → PostgreSQL (apenas cache miss)
```

Redis reduz carga no banco para dados frequentemente lidos (perfil de usuário, configurações, permissões). Regra prática: se o mesmo dado é lido >10x/minuto por usuário, é candidato ao cache.

### Fase 3: 100k-1M usuários (Filas + Read Replicas)

#### Filas de Mensagens

Writes síncronos falham sob carga. Se enviar email, processar pagamento e atualizar analytics no mesmo request HTTP → um dos três vai causar timeout.

**Pattern de fila:**
```
HTTP POST /order → 
  1. Persiste order (rápido, <5ms)
  2. Publica evento OrderCreated no Kafka/RabbitMQ
  3. Retorna 202 Accepted imediatamente
  
Worker consumers (paralelos):
  - email-worker: consome OrderCreated → envia email
  - analytics-worker: consome OrderCreated → atualiza métricas  
  - inventory-worker: consome OrderCreated → atualiza estoque
```

**Backpressure**: a fila absorve picos de tráfego. Se chegam 10k orders/minuto mas os workers processam 5k/minuto, a fila cresce mas o sistema não cai — processa com delay controlado.

#### Read Replicas

Se 80% do tráfego é leitura (típico em apps de conteúdo), uma réplica de leitura pode dobrar a capacidade do banco sem sharding:

```java
// Spring Boot: datasource routing por operação
@Transactional(readOnly = true)  // → read replica
public User findUser(Long id) { ... }

@Transactional  // → primary
public User updateUser(User user) { ... }
```

#### Database Connection Patterns

```
1k usuários → pool de 10 conexões (suficiente)
100k usuários → pool de 50 + pgBouncer
1M usuários → pgBouncer obrigatório (limita conexões físicas ao DB)
```

PostgreSQL suporta ~300-500 conexões físicas por instância — com 1M usuários, mesmo com pool no app, você precisa de um proxy de conexão.

## Decisões Irreversíveis (tome cedo)

Estas decisões são difíceis de mudar depois que o sistema está em produção com dados:

| Decisão | Por que é difícil mudar depois |
|---------|-------------------------------|
| ID strategy (UUID vs auto-increment) | Foreign keys em toda a base |
| Timezone storage (UTC vs local) | Dados históricos ficam inconsistentes |
| Soft delete vs hard delete | Queries de "all users" se comportam diferente |
| Monorepo vs polyrepo | Migração com CI/CD estabelecido é cara |
| Authn strategy (JWT vs sessions) | Clientes mobile em produção |

## O que NÃO fazer antes de 1M usuários

- **Microserviços prematuros**: o custo de rede, tracing distribuído e deploy independente não vale antes de ter times separados para cada serviço
- **Sharding manual**: a maioria dos apps nunca precisará; use read replicas primeiro
- **Kafka para eventos internos**: RabbitMQ é suficiente para <100k mensagens/dia

## Relevância para FIAP Fase 7

A Fase 7 do curso ADS @ FIAP usa Spring Boot + Next.js. Os conceitos diretamente aplicáveis:

- **Spring Boot**: `@Transactional(readOnly=true)` para roteamento automático para replica
- **Connection pooling**: HikariCP já está configurado por padrão no Spring Boot — ajustar `spring.datasource.hikari.maximum-pool-size`
- **Stateless APIs**: Spring Security + JWT elimina necessidade de `HttpSession`
- **Cache**: `@Cacheable` com Spring Cache + Redis Starter

Exemplo prático para o projeto da fase:
```java
@Service
public class UserService {
    @Cacheable(value = "users", key = "#id")
    @Transactional(readOnly = true)
    public UserDTO findById(Long id) {
        return userRepository.findById(id)
            .map(userMapper::toDTO)
            .orElseThrow(() -> new UserNotFoundException(id));
    }
}
```

## Limitações do Design para 1M

- 1M usuários **ativos simultâneos** é muito diferente de 1M usuários cadastrados — a maioria dos sistemas com 1M de cadastros tem 10-50k simultâneos
- O artigo assume workload web genérico — apps de real-time (gaming, trading) têm requisitos diferentes (WebSocket, state compartilhado)
- Custo de infra para este design pode ser proibitivo para startups early-stage sem funding

## Links
- [[02-AREAS/fiap/fase-7/fase-7-index]]
- [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]]
- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
