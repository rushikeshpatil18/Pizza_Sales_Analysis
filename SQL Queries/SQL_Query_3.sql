
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    c.category,
    (SUM(quantity * price) / (SELECT 
            ROUND(SUM(pizzas.price * order_details.quantity),
                        2) AS Revenue
        FROM
            order_details
                INNER JOIN
            pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100 AS revenue
FROM
    order_details AS a
        INNER JOIN
    pizzas AS b ON a.pizza_id = b.pizza_id
        INNER JOIN
    pizza_types AS c ON b.pizza_type_id = c.pizza_type_id
GROUP BY c.category;


-- Analyze the cumulative revenue generated over time.
select `date`,sum(revenue) over(order by `date`) as cum_revenue
from
(
	select c.`date`,sum(a.price*b.quantity) as revenue from pizzas as a
	inner join order_details as b
	on a.pizza_id=b.pizza_id
	inner join orders as c
	on b.order_id=c.order_id 
	group by c.`date`
) as sales_revenue;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category,pizza_name,revenue,rank_num
FROM
(
    SELECT pt.category,pt.name AS pizza_name,
        SUM(p.price * od.quantity) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(p.price * od.quantity) DESC
        ) AS rank_num
    FROM pizza_types AS pt
    INNER JOIN pizzas AS p
        ON pt.pizza_type_id = p.pizza_type_id
    INNER JOIN order_details AS od
        ON p.pizza_id = od.pizza_id
    GROUP BY
        pt.category,
        pt.name
) AS ranked_pizzas
WHERE rank_num <= 3
ORDER BY category, rank_num;


-- Top 3 pizza types based on revenue.
select c.name,sum(a.quantity * b.price) as revenue
from order_details as a
inner join pizzas as b
on a.pizza_id=b.pizza_id
inner join pizza_types as c
on b.pizza_type_id=c.pizza_type_id
group by c.name
order by revenue desc limit 3;
