-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    c.category, SUM(a.quantity) AS quantity
FROM
    order_details AS a
        INNER JOIN
    pizzas AS b ON a.pizza_id = b.pizza_id
        INNER JOIN
    pizza_types AS c ON b.pizza_type_id = c.pizza_type_id
GROUP BY category;


-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS order_hour, COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY HOUR(time)
ORDER BY order_hour;
        
        
-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(total_quantity_per_day), 0) AS avg_order_quantity_per_day
FROM
    (SELECT 
        b.`date`, SUM(a.quantity) AS total_quantity_per_day
    FROM
        order_details AS a
    INNER JOIN orders AS b ON a.order_id = b.order_id
    GROUP BY `date`) AS order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    c.name, SUM(a.quantity * b.price) AS total_revenue
FROM
    order_details AS a
        INNER JOIN
    pizzas AS b ON a.pizza_id = b.pizza_id
        INNER JOIN
    pizza_types AS c ON b.pizza_type_id = c.pizza_type_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 3;
