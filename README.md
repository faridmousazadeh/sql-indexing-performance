# SQL Server Indexing & Query Performance

## Overview

This repository contains IST 659 examples involving SQL Server indexing and performance-oriented query design. The payroll, vBay, and Fudgemart examples demonstrate index designs intended to support specific query patterns, along with window-function analysis and an indexed view.

The repository does not include execution-plan captures or benchmark measurements, so it does not claim measured performance improvements.

## Course

**IST 659 — Data Administration Concepts and Database Management**  
Syracuse University

## Objectives

- Design nonclustered indexes around query predicates and projected columns.
- Use included columns to support query access patterns.
- Analyze bid data with ranking and window functions.
- Create and index a schema-bound view.
- Demonstrate a unique clustered index on an indexed view.
- Demonstrate a nonclustered columnstore index on the indexed-view output.
- Recognize that index design should be evaluated against actual execution evidence.

## Technical Skills

- SQL Server / T-SQL
- Nonclustered indexes and included columns
- Window functions: `DENSE_RANK`, `LAG`, and `LEAD`
- Indexed views and `WITH SCHEMABINDING`
- Unique clustered indexes
- Nonclustered columnstore indexes
- `NOEXPAND`
- Multi-table joins
- Filtering and aggregation

## Indexing and Performance Concepts

The examples define indexes in relation to the predicates, keys, and projected columns in specific queries. An index definition alone does not establish which access path the SQL Server optimizer will choose or demonstrate a measured performance change.

### Payroll

The script creates a nonclustered index on `employee_jobtitle` and includes `employee_firstname` and `employee_lastname`. Its queries filter for Store Manager and Owner job titles and group by job title.

The SQL comment describes `employee_id` as a primary key and says it is carried in the nonclustered index as the row locator when the table uses a clustered primary key. The repository does not include a schema definition verifying that `employee_id` is clustered.

### vBay

The bid-analysis query joins items, bids, and users and filters to bids with `bid_status = 'ok'`. It uses `DENSE_RANK` by `item_id` and bid timestamp, and `LAG` / `LEAD` by item with `bid_id` as a tie-breaker.

The supporting nonclustered index has keys `(bid_status, bid_item_id, bid_datetime, bid_id)` and includes `bid_user_id` and `bid_amount`. This describes the index design in the SQL; the repository contains no measurement showing that it made the query faster.

### Fudgemart

The script creates the schema-bound view `dbo.v_orders` using joins across `fm_orders`, `fm_customers`, `fm_order_details`, and `fm_products`. It then creates a unique clustered index on `(order_id, product_id)` and a nonclustered columnstore index containing the view's projected columns.

The SQL and design notes state that the unique clustered key assumes each order/product pair is unique in the detail rows. The example queries use `NOEXPAND`, including a grouped quantity summary and a distinct customer/product-department query. The documentation notes that creating a nonclustered columnstore index on an indexed view requires SQL Server 2016 or later.

## Examples / Query Workloads

| Area | Query pattern | Index or SQL technique |
| --- | --- | --- |
| Payroll | Filter employees by job title and group employees by job title | Nonclustered index on `employee_jobtitle` with included name columns |
| vBay | Rank successful bids and show adjacent bidders by item and time | Window functions and a nonclustered index on bid status, item, timestamp, and bid ID |
| Fudgemart | Summarize order details from a multi-table view | Schema-bound indexed view, unique clustered index, nonclustered columnstore index, and `NOEXPAND` |

## Key SQL Techniques

- `CREATE NONCLUSTERED INDEX` with `INCLUDE`
- `DENSE_RANK()`, `LAG()`, and `LEAD()`
- Multi-table `INNER JOIN`
- Filtering by job title and successful bid status
- `GROUP BY`, `COUNT(*)`, `SUM()`, and `DISTINCT`
- `WITH SCHEMABINDING`
- Unique clustered index creation on a view
- Nonclustered columnstore index creation
- Indexed-view queries with `NOEXPAND`
- SQL Server SET options used when creating the indexed view and indexes

## Project Structure

```text
sql-indexing-performance/
├── README.md
├── .gitignore
├── docs/
│   ├── design-notes.md
│   └── verification-notes.md
└── sql/
    ├── 01_payroll_jobtitle_index.sql
    ├── 02_vbay_bid_ranking.sql
    └── 03_fudgemart_indexed_view.sql
```

## Execution Context

The scripts target the course databases `payroll`, `vbay`, and `fudgemart_v3` in Microsoft SQL Server. Run each script in the corresponding database in SQL Server Management Studio or Azure Data Studio.

The scripts drop and recreate named indexes. The Fudgemart script also removes and rebuilds `dbo.v_orders` and its indexes. Review the target database before running the scripts. The indexed-view columnstore example requires SQL Server 2016 or later, as noted in the repository documentation.

## Verification / Limitations

The verification notes state that the SQL and execution plans were not run or captured because the course databases were unavailable in the audit workspace. The repository contains no execution-plan screenshots or exports, benchmark timings, before-and-after query measurements, or measured percentage improvements.

The README describes index designs and performance-oriented query techniques only. It does not claim that a plan used a particular index or that a query became faster.

## Key Takeaways

The coursework demonstrates how SQL Server indexes can be designed around query patterns and how ranking functions and indexed views can be used in performance-oriented examples. Actual plan choice and performance require evaluation in the target database with its schema, data, statistics, version, and session settings.

## Course Context

This repository presents SQL Server indexing and query-performance coursework from **IST 659 — Data Administration Concepts and Database Management** at Syracuse University, Problem Set 9.
