use pizza_dataset;

-- Retrieve the total number of orders placed.
select count(order_id)as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(pizzas.price * order_details.quantity),2) as Revenue 
from order_details
inner join pizzas
on order_details.pizza_id=pizzas.pizza_id;


-- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price from pizza_types inner join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Identify the most common pizza size ordered.
select count(a.quantity)as most_ordered_size,b.size 
		from order_details as a
inner join pizzas as b
		on a.pizza_id=b.pizza_id
		group by b.size
		order by most_ordered_size desc limit 1;
        
        
-- List the top 5 most ordered pizza types along with their quantities.
select c.name,count(a.quantity) as total_count from order_details as a
inner join pizzas as b
on a.pizza_id=b.pizza_id
inner join pizza_types as c
on b.pizza_type_id=c.pizza_type_id
group by c.name
order by total_count desc limit 5;



			
