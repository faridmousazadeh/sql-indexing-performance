# Design notes

## Payroll covering index

The index keys `employee_jobtitle`, the query predicate, and includes the two selected name columns. The employee identifier is expected to be the primary key; when that is the clustered key, SQL Server stores it in each nonclustered index as the row locator. The grouping query touches only the index key and aggregate, so a scan of the narrow index can be cheaper than reading the base table.

## vBay bid ranking

The query now partitions by `item_id` rather than `item_name`, avoiding accidental mixing if two items share a name. `DENSE_RANK` keeps equal timestamps tied. `LAG` and `LEAD` add `bid_id` as a deterministic tie-breaker for adjacent bidders. The index key starts with `bid_status` for the equality filter, then orders by item and time; included columns cover bidder ID and bid amount. SQL Server may still choose a scan based on the actual data and statistics.

## Fudgemart indexed view

The view uses schema-qualified base tables and deterministic expressions from the assignment. The unique clustered index assumes each order/product pair is unique in the detail rows. If the target schema allows repeated product lines per order, the key must be expanded with the actual line identifier.

The view's nonclustered columnstore contains every projected column and supports the two sample analytical queries. Microsoft documents creating a nonclustered columnstore index on an indexed view beginning with SQL Server 2016; older course instances will need a different approach.

## Plan interpretation

Execution plans are data- and statistics-dependent. The scripts do not force an index seek for the payroll or vBay queries. Use actual plans and logical reads on the provisioned course databases to compare alternatives; an index's existence alone does not prove a speedup.
