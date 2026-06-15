# Skill: fatura-parser

Referência de formatos de PDF por banco. Usada por `Fatura` para detecção e extração.

---

## Detecção de Banco

| Banco | Indicadores no PDF |
|-------|-------------------|
| Santander | "Banco Santander", "SANTANDER", cabeçalho com "Fatura do Cartão", logo vermelho |
| Porto Seguro | "Porto Seguro", "PORTO SEGURO CARTÕES", "Cartão Porto Seguro" |
| Revolut | "Revolut", "Statement", moeda EUR/GBP/USD predominante, formato inglês |

---

## Santander

**Formato típico:**
- Cabeçalho: nome do titular, número do cartão (últimos 4), período ("DD/MM a DD/MM/YYYY")
- Seção de lançamentos: lista com colunas `Data | Descrição | Valor`
- Parcelamentos indicados com "(X/Y)" após descrição ou coluna "Parcela"
- Totais: "Total de lançamentos nacionais", "Total de lançamentos internacionais"
- IOF separado em linha própria — ignorar na análise de gastos
- Fatura internacional: converte USD→BRL na linha; usar valor em BRL

**Atenção Santander:**
- Compras no exterior têm spread cambial embutido no valor BRL — não desdobrar
- "Pagamento recebido" e "Crédito" são estornos → subtrair da categoria correspondente

---

## Porto Seguro

**Formato típico:**
- Cabeçalho: "FATURA", número do cartão, data de vencimento, valor total
- Transações agrupadas por titular (titular + adicionais em blocos separados)
- Colunas: `Data | Estabelecimento | Valor | Parcelas`
- Seguros Porto Seguro (Auto, Residencial) aparecem como cobranças recorrentes → categoria ASS
- Pontos Azul são exibidos mas ignorar para análise financeira

**Atenção Porto Seguro:**
- Bloco "Adicionais" — somar ao total mas marcar titular no campo descrição
- "Proteção de Cartão" — cobrado mensalmente → ASS

---

## Revolut

**Formato típico:**
- Statement em inglês; moedas múltiplas (BRL, USD, EUR, GBP)
- Colunas: `Date | Description | Amount | Currency | Balance`
- Transações em moeda estrangeira têm linha separada com a taxa de câmbio aplicada
- "Top up" e "Transfer" não são gastos → ignorar
- "Cashback" e "Reward" são créditos → subtrair se relevante

**Atenção Revolut:**
- Converter todos os valores para BRL usando taxa da linha ou do mês de fechamento
- Assinaturas Revolut (Premium, Metal) → ASS
- ATM withdrawals → OUT (saques)

---

## Transações a Ignorar (todos os bancos)

- Pagamento de fatura / crédito de pagamento
- IOF sobre transações internacionais (linha separada)
- Encargos por atraso / juros rotativos
- Saldo anterior
- Limite disponível / limite total

---

## Tratamento de Parcelamentos

Para cada parcela ativa:
1. Registrar valor da parcela atual (o que está sendo cobrado agora)
2. Registrar parcela restante: `(X/Y)` → restam `Y - X` parcelas
3. Calcular comprometimento futuro: `(Y - X) × valor_parcela`
4. Listar na seção "Comprometimento Futuro" do relatório

---

## Fallback: PDF ilegível

Se `read_media_file` não retornar texto estruturado:
1. Tentar `read_file` em modo texto
2. Se falhar: solicitar ao usuário exportar via app do banco:
   - Santander: App → Cartão → Fatura → Exportar PDF (ou CSV no portal web)
   - Porto Seguro: Portal web → Minha Conta → Faturas → Download
   - Revolut: App → Conta → Statements → Export CSV
