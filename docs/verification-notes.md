# Verification notes

- Reviewed the Problem Set 9 prompt and submitted SQL and organized the work into payroll, vBay, and Fudgemart exercises.
- Included the output queries described by the assignment; the Fudgemart examples include `NOEXPAND` to request indexed-view use.
- SQL and execution plans were not run or captured because the payroll, vBay, and fudgemart_v3 databases are not attached in this workspace.
- The unique clustered view index depends on `(order_id, product_id)` being unique. The vBay index seek and indexed-view plan choice depend on the target SQL Server version, schema, data, statistics, and session SET options.
- No screenshots, query-plan exports, or database data are included.
