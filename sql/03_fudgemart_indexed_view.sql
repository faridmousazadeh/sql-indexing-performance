USE fudgemart_v3;
GO

-- Indexed views require these SET options when the view/index is created and
-- when the optimizer is expected to use the indexed view.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO

-- Remove prior indexes before replacing the schemabound view.
IF OBJECT_ID('dbo.v_orders', 'V') IS NOT NULL
BEGIN
    IF EXISTS
    (
        SELECT 1 FROM sys.indexes
        WHERE object_id = OBJECT_ID('dbo.v_orders')
          AND name = 'ix_v_orders_columnstore'
    )
        DROP INDEX ix_v_orders_columnstore ON dbo.v_orders;

    IF EXISTS
    (
        SELECT 1 FROM sys.indexes
        WHERE object_id = OBJECT_ID('dbo.v_orders')
          AND name = 'ix_v_orders'
    )
        DROP INDEX ix_v_orders ON dbo.v_orders;

    DROP VIEW dbo.v_orders;
END;
GO

CREATE VIEW dbo.v_orders
WITH SCHEMABINDING
AS
    SELECT c.customer_state,
           c.customer_firstname + ' ' + c.customer_lastname AS customer_name,
           DATEPART(year, o.order_date) AS order_year,
           o.order_id,
           o.ship_via,
           od.order_qty AS order_detail_qty,
           od.order_qty * p.product_retail_price AS order_detail_extd_price,
           p.product_id,
           p.product_name,
           p.product_department
    FROM dbo.fm_orders AS o
    INNER JOIN dbo.fm_customers AS c
        ON c.customer_id = o.customer_id
    INNER JOIN dbo.fm_order_details AS od
        ON od.order_id = o.order_id
    INNER JOIN dbo.fm_products AS p
        ON p.product_id = od.product_id;
GO

-- Requires (order_id, product_id) to uniquely identify each view row.
CREATE UNIQUE CLUSTERED INDEX ix_v_orders
ON dbo.v_orders (order_id, product_id);
GO

SELECT *
FROM dbo.v_orders WITH (NOEXPAND);
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX ix_v_orders_columnstore
ON dbo.v_orders
(
    customer_state,
    customer_name,
    order_year,
    order_id,
    ship_via,
    order_detail_qty,
    order_detail_extd_price,
    product_id,
    product_name,
    product_department
);
GO

SELECT product_name,
       SUM(order_detail_qty) AS units_ordered
FROM dbo.v_orders WITH (NOEXPAND)
GROUP BY product_name;
GO

SELECT DISTINCT customer_name, product_department
FROM dbo.v_orders WITH (NOEXPAND);
GO
