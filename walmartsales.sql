create database if not exists salesdatawalmart;
use salesdatawalmart;
create table sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null ,
city varchar(30) not null ,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100),
unit_price decimal(10,2) not null,
quantity int not null,
vat float(6,4),
total decimal(12,4),
date datetime not null,
time time not null,
payment_method varchar(15) not null,
COGS decimal(10,2) not null,
gross_margin_percentage float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)
);

-- FEATURE ENGINEERING------------------------------------------------------------------------------------
select time,(case 
when time between '00:00:00' and '12:00:00' then "Morning"
when time between '12:01:00' and '16:00:00' then "Afternoon"
	else "Evening" end) as time_of_day from sales;
    
alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day = (case 
when time between '00:00:00' and '12:00:00' then "Morning"
when time between '12:01:00' and '16:00:00' then "Afternoon"
	else "Evening" end);
    
-- day_name

select date, dayname(date) as name_of_day from sales;

alter table sales add column name_of_day varchar(10);

update sales
set name_of_day = dayname(date);

-- month name

select date,monthname(date) as name_of_month from sales;


alter table sales add column name_of_month varchar(10);

update sales
set name_of_month = monthname(date);

-- EDA -------------------------------------------------------------------------------

-- How many unique cities does the data have?
select 
	distinct city 
from sales;
-- in wich city id each branch?
select distinct branch from sales;

select distinct city,branch from sales;
-- How many unique product lines does this data have?
select count(distinct product_line) from sales;
-- what is the most common payment method?
select payment_method,count(payment_method) as cnt from sales
group by payment_method
order by cnt desc;

-- what is the most selling product line?
select product_line, count(product_line) as total_sale from sales
group by product_line
order by total_sale desc;

-- what is the total revenue by month ?
select name_of_month as month , sum(total) as revenue from sales
group by name_of_month
order by revenue desc;
-- what month had the largest cogs?
select name_of_month,sum(COGS) as no_of_cogs from sales
group by name_of_month
order by no_of_cogs desc;
-- what product line had the largest revenue?
select product_line, sum(total) as largest_revenue from sales 
group by product_line 
order by largest_revenue desc;

-- what is the city with the largest revenue?
select city,branch, sum(total) as largest_revenue from sales 
group by city ,branch
order by largest_revenue desc;

-- waht product line had the largest vat?
select product_line, avg(vat) as avg_vat from sales 
group by product_line 
order by avg_vat desc;

-- wich branch sold more products than avg product sold?
select branch, sum(quantity) as qty from sales
group by branch 
having qty>(select avg(quantity) from sales);

-- what is the most common product line by gender ?

select gender,product_line, count(product_line)as cnt from sales
group by gender,product_line
order by cnt desc;

-- What is the avg rating of each product line?
select product_line, round(avg(rating),2) as avg_rating from sales
group by product_line
order by avg_rating desc;


-- SALES ------------------------------------------------------------------------------

-- Number of sales made in eaach time per day weekly?

select time_of_day,count(quantity) as sales from sales 
where name_of_day= "Monday"
group by time_of_day
order by sales desc;

-- which customer type brings most revenue ?
select customer_type , sum(total) as revenue from sales
group by customer_type 
order by revenue desc;

-- whhich city has highest vat ?
select city , avg(vat) as avg_tax from sales
group by city 
order by avg_tax desc;

-- which customer type pays the most vat?
select customer_type , avg(vat) as avg_tax from sales 
group by customer_type 
order by avg_tax desc;

-- CUSTOMER ----------------------------------------------------------------------------

-- How many unique customer types does the data have?

select distinct customer_type from sales;

-- what is the most common customer type ?

select customer_type, count(customer_type) from sales
group by customer_type 
order by count(customer_type) desc;

-- what gender is most of the customers?

select gender,count(gender) from sales 
group by gender 
order by count(gender) desc;

-- which customer type buys the most;
select customer_type , sum(quantity) from sales 
group by customer_type 
order by sum(quantity) desc;
-- what is gender distribution per branch?
select gender , count(gender) from sales 
where branch = 'C'
group by gender;