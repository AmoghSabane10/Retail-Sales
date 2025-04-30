create table retail_sales (
	transactions_id INT primary key,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender Varchar(30),
	age INT,
	category Varchar(30),
	quantiy INT,
	price_per_unit Float,
	cogs Float,
	total_sale Float
);

-- deleting nulls 
delete from retail_sales
where quantiy is null;

-- checking number of unique customers
select count (distinct(customer_id)) from retail_sales;

-- number of unique categories
select count (distinct(category)) from retail_sales;

-- sales done on a specific date
select * from retail_sales
where sale_date = '2022-11-05';

-- retrieve entries where category is clothing and date is Nov 22 with quantity more than 10
select * from retail_sales
where category='Clothing' 
and to_char(sale_date, 'YYYY-MM')='2022-11'
and quantiy>3;

-- total sales for each category

select category, sum(total_sale), count(*) as total_orders from retail_sales
group by category;

-- average age of customers from the beauty category

select round(avg(age),2), category from retail_sales 
where category = 'Beauty'
group by category;

-- where total sale is >1000
select * from retail_sales 
where total_sale > 1000;

-- number of transactions by gender
select category, gender, count(*) from retail_sales
group by category,gender
order by 1;

-- best selling month in each year

select avg_sale, year, month from (select avg(total_sale) as avg_sale, extract('Year' from sale_date) as year, extract('Month' from sale_date) as month, 
Rank() Over(Partition by extract('Year' from sale_date) order by avg(total_sale) desc) from retail_sales
group by 2,3
order by 2,3 desc) as t1 
where rank =1;


-- top 5 customers based on total sale

select customer_id, sum(total_sale) from retail_sales 
group by customer_id 
order by sum(total_sale) desc
limit 5;

-- number of unique customers who purchased from each category

select count( distinct(customer_id)) as unique_customers, category from retail_sales 
group by category; 

-- finding number of orders per shift

with hourly_sales as (select *,
		case 
		when Extract(Hour from sale_time)< 12 then 'Morning'
		when Extract(Hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'evening'
		end as shift
from retail_sales)

select shift, count(*) as total_orders, avg(total_sale) from hourly_sales 
group by shift;


