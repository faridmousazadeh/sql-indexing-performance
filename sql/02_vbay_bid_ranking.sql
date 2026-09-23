USE vbay;
GO

DROP INDEX IF EXISTS ix_bid_status_item_datetime ON dbo.vb_bids;
GO

-- Status supports the equality predicate; item and time keys align with the
-- partition/order operations. bid_id gives deterministic ordering for ties.
CREATE NONCLUSTERED INDEX ix_bid_status_item_datetime
ON dbo.vb_bids (bid_status, bid_item_id, bid_datetime, bid_id)
INCLUDE (bid_user_id, bid_amount);
GO

-- DENSE_RANK intentionally treats bids at the same timestamp as tied.
-- LAG/LEAD add bid_id as a stable tie-breaker so adjacent bidders are repeatable.
SELECT i.item_id,
       i.item_name,
       DENSE_RANK() OVER
           (PARTITION BY i.item_id ORDER BY b.bid_datetime) AS bid_order,
       b.bid_amount,
       LAG(u.user_firstname + ' ' + u.user_lastname) OVER
           (PARTITION BY i.item_id ORDER BY b.bid_datetime, b.bid_id) AS prev_bidder,
       u.user_firstname + ' ' + u.user_lastname AS bidder,
       LEAD(u.user_firstname + ' ' + u.user_lastname) OVER
           (PARTITION BY i.item_id ORDER BY b.bid_datetime, b.bid_id) AS next_bidder
FROM dbo.vb_items AS i
INNER JOIN dbo.vb_bids AS b
    ON b.bid_item_id = i.item_id
INNER JOIN dbo.vb_users AS u
    ON u.user_id = b.bid_user_id
WHERE b.bid_status = 'ok'
ORDER BY i.item_id, b.bid_datetime, b.bid_id;
GO
