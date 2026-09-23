USE payroll;
GO

DROP INDEX IF EXISTS ix_employee_jobtitle ON dbo.employees;
GO

-- employee_id is the primary key and is carried by the nonclustered index
-- row locator when the table uses a clustered primary key.
CREATE NONCLUSTERED INDEX ix_employee_jobtitle
ON dbo.employees (employee_jobtitle)
INCLUDE (employee_firstname, employee_lastname);
GO

-- Assignment query: filter to the two job titles.
SELECT employee_id,
       employee_firstname,
       employee_lastname,
       employee_jobtitle
FROM dbo.employees
WHERE employee_jobtitle = 'Store Manager'
   OR employee_jobtitle = 'Owner';
GO

-- GROUP BY query over the indexed key. The optimizer may scan the narrow
-- nonclustered index because all job titles are requested.
SELECT employee_jobtitle,
       COUNT(*) AS employee_count
FROM dbo.employees
GROUP BY employee_jobtitle;
GO
