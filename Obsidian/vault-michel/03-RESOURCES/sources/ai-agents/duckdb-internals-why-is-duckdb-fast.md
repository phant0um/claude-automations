---
title: "DuckDB Internals: Why is DuckDB Fast?"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - source
  - data-engineering
  - duckdb
  - database-internals
  - columnar-storage
  - query-optimization
---

author: [[Kyle Cheung]]
source: https://www.greybeam.ai/blog/duckdb-internals-part-1
published: 2026-05-04

## Central Thesis

DuckDB's speed comes from a handful of deliberate design choices: (1) in-process execution (no serialization overhead), (2) columnar compressed storage with zone maps, (3) vectorized execution, (4) morsel-driven parallelism, and (5) snapshot isolation with optimistic MVCC. This article (Part 1 of 3) covers the path from SQL to the moment the engine is ready to run, plus the storage layer the query reads from.

## Key Arguments

### What is DuckDB?

An **in-process analytical SQL database.** *Analytical* = optimized for queries that scan millions of rows to filter, aggregate, and join (not single-record lookups). *In-process* = no server; you load it as a library like NumPy or Polars. Ships as a single binary under 20 MB with no external dependencies. Opens any directory of Parquet, CSV, or JSON files as if they were already a SQL database.

### Queries Run In-Process

Most analytical databases are servers (Snowflake, Postgres, BigQuery, Redshift). You connect, send SQL over TCP, wait for results. Every record is serialized into a wire protocol, transmitted, and deserialized. This is often the **slowest single step** — sometimes dwarfing the compute time.

Two costs drive this:
1. **Raw bandwidth:** gigabit Ethernet caps at ~125 MB/s; large results take longer to transmit than to compute
2. **Per-value overhead:** ODBC/JDBC hand back results one row/value at a time — hundreds of millions of function calls, each doing memory copy, type check, string allocation

DuckDB sidesteps both by living in the same process. When a Python script runs `con.sql("SELECT ... FROM my_df")`, DuckDB uses a **replacement scan** — it replaces the table reference with a function that reads from the dataframe at query time, potentially **zero-copy** (reading the same NumPy buffers the Python process already owns).

Arrow is the cleanest version of this story — already columnar and typed for sharing between systems.

### From SQL to Logical Plan

**Parsing:** SQL → AST (abstract syntax tree). DuckDB uses a fork of the Postgres parser, which is why its dialect feels familiar. The AST is a tree where each node is a syntactic construct (SELECT, column reference, function call, join, literal).

**Binding:** Resolves every name against the catalog. `lineitem` → specific table with known schema. `l_quantity` → specific column with known type. `sum` → specific aggregate function. Type checking happens here. Output is a bound tree where every node knows what it refers to and what type it produces.

**The Optimizer:** A sequence of small, focused transformations you can inspect and disable individually (`SET disabled_optimizers = 'filter_pullup, join_order'`). 33 optimizers total. Interesting ones:

- **Filter pushdown:** Move WHERE predicates as close to the scan as possible. DuckDB first pulls filters up to combine/reorganize, then pushes them back down.
- **Subquery unnesting:** Correlated subqueries traditionally force re-execution per outer row. DuckDB implements techniques from *Unnesting Arbitrary Queries* to rewrite as joins.
- **Dynamic join-filter pushdown:** During hash join, once the build side is in memory, compute min/max of join keys and push those bounds back into the probe-side scan as a runtime filter. When <50 distinct join key values, filter becomes an IN list instead of min-max range.
- **Join order optimization:** Most consequential decision. A 6-table join has 30,240 possible tree shapes. DuckDB uses dynamic programming (DPhyp, DPccp): if you've found the best way to join {a,b,c}, reuse that answer for {a,b,c,d}.
- Entire optimization phase usually finishes in ~1 millisecond.

### The Physical Plan

The optimizer's output is still a logical plan. Most logical steps have several physical implementations (hash join, index join, piecewise merge join, cartesian join). DuckDB picks a physical operator for each node.

**Pipelines:** The physical plan is not one giant tree walk. DuckDB breaks it into pipelines — assembly lines where each station does one thing (drop a row, transform a column, look up in hash table) and hands the result to the next. Each pipeline parallelizes cleanly across cores.

**Pipeline breakers (sinks):** Some operators can't work streaming — they need the entire input first:
- `ORDER BY` can't emit until it's seen every row
- `GROUP BY` can't emit final sum until all rows accounted for
- Build side of hash join must build the table first

These mark the end of one pipeline and the beginning of the next. The physical plan is a sequence of pipelines stitched by sinks.

**Sink phases:** sink (each thread writes to local state, no locks), combine (merge local states across all cores in parallel), finalize (read out as input to next pipeline).

**Parallelism is local:** DuckDB doesn't plan global parallelism for the whole query — it parallelizes one pipeline at a time. This is what makes morsel-driven parallelism and vectorized execution work.

### The Storage Layer

A DuckDB database is a single file (`.duckdb` or `.db`), inspired by SQLite. Inside: fixed-size blocks (default 256 KB), each with a checksum (protects against bit flips from cosmic rays, firmware bugs, flaky cables — consumer hardware has less protection than cloud warehouses).

**Columnar storage:** Row stores keep entire records contiguous (fast for `SELECT * WHERE id = 42`). Column stores keep columns contiguous — a query reading 4 columns from a 300-column table only reads those 4 columns. This is why column stores (Snowflake, BigQuery, ClickHouse) are used for analytics.

**Row groups:** Each column split into row groups of up to 122,880 rows, then into column segments mapping to single 256 KB blocks. A row group is a unit of parallelism — 8 threads should have ≥8 row groups.

**Zone maps:** Each row group carries min/max values + null count. When scanning with `WHERE event_date > '2026-01-01'`, DuckDB checks each row group's max before reading. Row groups whose max is ≤ the predicate are skipped entirely. Effectiveness depends on column ordering — sorted columns give narrow min-max spans; random values give wide spans.

Equivalent in other warehouses: Snowflake = micro-partition pruning, BigQuery = block pruning, ClickHouse = minmax data skipping indexes.

**Parquet:** Most practitioners query Parquet directly, not DuckDB tables. Parquet shares design principles: columnar, min/max statistics per row group per column. DuckDB reads the footer for schema and statistics, determines which row groups satisfy predicates, reads only needed column chunks, decompresses, feeds into pipelines. For remote files, DuckDB fetches only the needed bytes via HTTP requests — a well-pruned WHERE clause dramatically improves over-the-wire performance.

**CSV sniffer:** CSVs aren't self-describing. DuckDB auto-detects dialect (delimiter, quote, escape, newline — e.g., `|` not `,` when city names contain commas), column types (tries candidate types in priority: NULL → BOOLEAN → TIME → DATE → TIMESTAMP → ... → VARCHAR as fallback), and headers (first row different from below = column names, else `column0`, `column1`, ...). Works from a 20,480-row sample by default.

## Key Insights

- **In-process is the biggest architectural advantage.** No serialization/deserialization, no network, potentially zero-copy from Python buffers. The client protocol is often the slowest step in traditional warehouses.
- **33 optimizers in ~1ms.** The optimization phase is fast because each pass is small and focused. You can inspect and disable individual optimizers for debugging.
- **Dynamic join-filter pushdown is a powerful technique.** Computing min/max from the build side and pushing it back as a runtime filter to the probe-side scan — combined with zone maps — can skip entire row groups before reading.
- **Zone map effectiveness depends on data ordering.** This is a subtle but critical insight: the same zone map mechanism works great on sorted data and poorly on random data.
- **Parallelism is per-pipeline, not per-query.** DuckDB doesn't plan global parallelism — it parallelizes one pipeline at a time, giving each thread its own morsel and own local state.
- **Checksums matter for consumer hardware.** Cloud warehouses have error correction in memory and disk redundancy; laptops and edge devices don't. DuckDB's per-block checksum is a practical backstop.
- **Parquet's footer-first reading enables selective byte-range fetches.** Over HTTP, this means a good WHERE clause can avoid downloading most of a remote file.

## Related Concepts

- [[03-RESOURCES/concepts/data-engineering/medallion-architecture]]
- [[03-RESOURCES/concepts/software-engineering/data-metadata-patterns]]