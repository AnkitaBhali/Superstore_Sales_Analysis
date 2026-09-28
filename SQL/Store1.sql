Create database superstore_db;
use superstore_db;

Create table orders(
 ROW_ID INT,
 Order_id varchar(20),
 order_date varchar(20),
 ship_date varchar(20),
 ship_mode varchar(50),
 customer_id varchar(20),
 customer_name varchar(100),
 segment varchar(50),
 country varchar(50),
 city varchar(100),
 state varchar(50),
 postal_code varchar(10),
 region varchar(50),
 product_id varchar(20),
 category varchar(50),
 sub_category varchar(50),
 product_name varchar(255),
 sales decimal(10,2),
 quantity int,
 discount decimal(4,2),
 profit decimal(10,2)
);

describe orders;

/*its not needed create duplicates*/
ALTER TABLE orders ADD COLUMN order_date_fixed DATE;
ALTER TABLE orders ADD COLUMN Ship_Date_fixed DATE;

/*useful*/
UPDATE orders 
SET Order_Date_fixed = STR_TO_DATE(Order_Date, '%m/%d/%Y'),
    Ship_Date_fixed = STR_TO_DATE(Ship_Date, '%m/%d/%Y');



select order_date, Order_Date_fixed from orders limit 2000;

select count(*)
from orders
where Order_Date_fixed is null;

select distinct product_name
from orders
where product_name like '%A%';



/*KPI ANALYSIS*/


/* Total Sales */

select sum(sales) as total_sales
from orders;

/* Total Profit */

select sum(profit) as total_profit
from orders;

/* Total Quantity */
 
select sum(quantity) as total_quantity
from orders;

/* Total Orders */

select count(distinct order_id) as total_orders
from orders;

/* Total Customers */

select count(distinct customer_id) as total_customers
from orders;

/* Average Order Value*/

select round(sum(sales)/count(distinct order_id),2) as avg_order
from orders;

/* profit margin % */

select round(sum(profit)*100/sum(sales),2) as profit_margin
from orders;



/* CATEGORY ANALYSIS */

/* Sales by Category */

select category, sum(sales) total_sales
from orders
group by category
order by total_sales desc;


/* Profit by Category */

select category, sum(profit) total_profit
from orders
group by category
order by total_profit desc;


/* Category Contribution % */

select category, round(sum(sales)*100/(select sum(sales)from orders),2) as sales_percentage
from orders
group by category;




/*REGION ANALYSIS*/

/* Sales by Region */

select region, sum(sales) total_sales
from orders
group by region
order by total_sales desc;

/* Profit by Region */

select region, sum(profit) total_profit
from orders
group by region
order by total_profit desc;

/* Customer Count by Region*/

Select region, count(distinct customer_id) customers
from orders
group by region;

/* Best Performing Region */

select region, sum(sales) as total_sales
from orders
group by region 
order by total_sales desc
limit 1;



/* SEGMENT ANALYSIS */


/* Sales by Segment */

select segment, sum(sales)total_sales 
from orders
group by segment 
order by total_sales desc;


/* Profit by Segment*/

select segment,sum(profit) total_profit
from orders
group by segment
order by total_profit desc; 




/* PRODUCT ANALYSIS */

/* Sales by Sub_Category */

select sub_category,sum(sales)total_sales
from orders
group by sub_category
order by total_sales desc; 

/* Profit by Sub_category */

select sub_category,sum(profit) as total_profit
from orders
group by sub_category
order by total_profit desc;

/* Top 10 Products by Sales */

Select product_name,SUM(sales)  as total_sales
from orders
group by product_name
order by sum(sales) desc
limit 10;

/* Top 10 Products by profit */

select product_name, SUM(profit) AS total_profit
from orders
group by product_name
order by total_profit desc
limit 10;

/* loss making products */

select product_name, SUM(profit) total_profit
from orders
group by product_name
having sum(profit)<0
order by total_profit;



/* CUSTOMER ANALYSIS */

/* Top 10 Customers by Sales*/

select customer_name, sum(sales) total_sales
from orders
group by customer_name
order by total_sales desc
limit 10;

/* Top 10 Customers by profit*/

select customer_name, sum(profit) total_profit
from orders
group by customer_name
order by total_profit desc
limit 10;

/* Customer Order Frequency*/

 select customer_name,
 count(distinct order_id)total_orders
 from orders
 group by customer_name
 order by total_orders desc;
 
 
 
 /* TIME ANALYSIS */
 
 /* Yearly Sales */
 
 select year(order_date_fixed)year,
 sum(sales)total_sales
 from orders
 group by year(Order_Date_fixed);
 
 /* monthly sales trend */
 
 select year(order_date_fixed)year,
 month(order_date_fixed)month,
 sum(sales)total_sales
 from orders
 group by year(Order_Date_fixed),
 month(Order_Date_fixed);
 
 /* quarterly sales trend */

 select year(order_date_fixed)year,
 quarter(order_date_fixed)quarter,
 sum(sales)total_sales
 from orders
 group by year(Order_Date_fixed),
 quarter(Order_Date_fixed);

/* month sales trend */

 select year(order_date_fixed)year,
 month(order_date_fixed)month,
 sum(sales)total_sales
 from orders
 group by year(Order_Date_fixed),
 month(Order_Date_fixed);
 
 
 
 /* shipping analysis */

/* average shipping days*/

select ship_mode,
round(avg(datediff(ship_date_fixed,order_date_fixed)),2) as avg_shipping_days
from orders
group by ship_mode;



/* EXECUTIVE BUSINESS QUERY */

/* Top Customer in each region */

with customer_sales as (
select region,
customer_name,
sum(sales) total_sales,
row_number() over(partition by region 
order by sum(sales)desc
)rn
from orders
group by region,customer_name
)
select * from customer_sales
where rn = 1;


















