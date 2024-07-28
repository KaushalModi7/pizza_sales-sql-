CREATE DATABASE pizzahut;

SELECT * FROM pizzas;

SELECT * FROM pizza_types;

SELECT * FROM orders;

SELECT * FROM order_details;

select count(order_id) as total_orderplaced  from orders;

select round(sum(order_details.quantity * pizzas.price),2) as total_revenue
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;

select pizza_types.name,pizzas.price
from pizza_types join pizzas on
pizza_types.pizza_type_id = pizzas.pizza_type_id order by pizzas.price desc limit 1;

select pizzas.size,count(order_details.order_id) as order_count from pizzas join order_details 
on pizzas.pizza_id = order_details.pizza_id group by pizzas.size order by order_count desc limit 1 ;

select pizza_types.name as pizzas_name,sum(order_details.quantity) as total_quantity from pizza_types 
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by pizzas_name order by total_quantity desc limit 5;

select pizza_types.category as categories ,sum(order_details.quantity) as total_quantity 
from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by categories  order by total_quantity desc limit 5;

select hour(time) as total_hours,count(order_id) as total_orders from orders group by total_hours;

select category,count(name) from pizza_types
group by category;

select avg(quantity) from 
(select orders.date,sum(order_details.quantity) as quantity from 
orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as order_quantity;

select pizza_types.name,sum(order_details.quantity * pizzas.price ) as revenue
from pizza_types join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id 
group by pizza_types.name order by revenue desc limit 3;

select date,sum(revenue) over(order by date) as cum_revenue
from
(select orders.date,sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.date) as sales;

select name,revenue from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from 
(select pizza_types.category,pizza_types.name,sum((order_details.quantity)* pizzas.price) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b
where rn <=3;
