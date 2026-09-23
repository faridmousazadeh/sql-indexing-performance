# SQL Indexing and Query Performance

A portfolio edition of IST 659 Problem Set 9. It compares nonclustered index designs, ranks vBay bids, and builds an indexed view for Fudgemart reporting.

## Exercises

| File | Database | Focus |
| --- | --- | --- |
| [`sql/01_payroll_jobtitle_index.sql`](sql/01_payroll_jobtitle_index.sql) | payroll | Cover the Store Manager/Owner filter and a grouped job-title query. |
| [`sql/02_vbay_bid_ranking.sql`](sql/02_vbay_bid_ranking.sql) | vbay | Rank successful bids and compare predecessor/successor bidders with a supporting index. |
| [`sql/03_fudgemart_indexed_view.sql`](sql/03_fudgemart_indexed_view.sql) | fudgemart_v3 | Create a schemabound view, a unique clustered index, a nonclustered columnstore index, and sample analytical queries. |
| [`docs/design-notes.md`](docs/design-notes.md) | — | Index choices, model assumptions, and interpretation of plans. |
| [`docs/verification-notes.md`](docs/verification-notes.md) | — | Validation boundaries and database dependencies. |

## Run notes

Execute each script in SQL Server Management Studio or Azure Data Studio against the course database it names. The scripts replace the indexes/view with the same names so they can be rerun in the course environment. The Fudgemart script temporarily removes and rebuilds `dbo.v_orders` and its indexes.

An index definition does not guarantee SQL Server will choose an index seek. The optimizer weighs selectivity, table size, statistics, and costs; capture an actual execution plan in the target database to demonstrate the chosen plan. No plan screenshots are included because the course databases are not available here.

The indexed-view columnstore example requires SQL Server 2016 or later. See [Microsoft Learn: CREATE COLUMNSTORE INDEX](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-columnstore-index-transact-sql?view=sql-server-ver17).
