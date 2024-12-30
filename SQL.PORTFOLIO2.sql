-- 1. How many distinct unknown customers made a purchase in 2012 from Bangalore 
---Merchant location?

--Solution	
	
	select year(convert(date,order_time,105)) year
	, Gender , 
	count( distinct c.Customer_ID) [count_orders]
     from transactions t inner join customer c
	on t.user_id = c.customer_id inner join Product p 
	on p.Merchant_id = t.merchant_id and t.product_id = p.Product_Id 
	where Gender = 'unknown' 
	and Merchant_Location = 'Bangalore' 
	and 
	year(convert(date,order_time,105)) = 2012
	group by Gender , year(convert(date,order_time,105))




-- 2. Calculate the Product sub-category wise Total sales for the Delhi merchant location.

--Solution
	
	select Sub_category_name , 
	sum(convert(float,sale_amount)) [tot_amt]
	from Transactions t inner join Product p
	on t.product_id = p.Product_Id
	and
	t.merchant_id = p.Merchant_id
	where Merchant_Location = 'Delhi'
	group by Sub_category_name


-- 3. Find the top 5 customers who redeemed the most reward points in 2013, where the 
---merchant is in Hyderabad or Ghaziabad.


---Solution 
       
	   select top 5 Customer_ID,
		SUM(cast(Points_redemed as int)) as points
		from Customer as c
		inner join Transactions as t on c.Customer_ID = t.User_Id
		inner join Product as p 
		on t.Merchant_id = p.Merchant_id 
		and 
		t.Product_id =p.Product_Id
		where year(convert(date,order_time,105)) = 2013
		and
		Merchant_Location in('hyderabad','gaziabad')
		group by Customer_ID
		order by points desc



-- 4. What is the average sale value for the top 10 customers in terms of transactions in 
---2012?


---Solution
	
	select sum(yeahh) / sum(yeah)
	from
			(
    select top 10 c.Customer_ID, sum(convert(float,sale_amount)) [yeahh] , count(order_id) [yeah]
	from Customer c inner join Transactions t
	on c.Customer_ID = t.USER_ID
	where year(convert(date,order_time,105)) = 2012
    group by c.Customer_ID 
	order by yeah desc
	) sub1


-- 5. Find the top 5 product sub-categories sold in the last 4 months (up to the last date, 31 
---March 2013) by sales, and calculate their percentage contribution to overall sales.


---Solution

    
	select *,(total_sales / (select SUM(cast(Sale_amount as float)) 
	from Transactions where 
	convert(date,order_time,105) between DATEADD
	(MONTH,-4,'2013-03-31') and '2013-03-31')) * 100
	as perc_contribution
    from(
	select top 5 Sub_category_Name, 
	SUM(cast(Sale_amount as float)) as total_sales
	from Transactions as t
	inner join Product as p 
	on t.Merchant_id = p.Merchant_id 
	and 
	t.Product_id = p.Product_Id
	where convert(date,order_time,105) between
	DATEADD(MONTH,-4,'2013-03-31') and '2013-03-31'
	group by Sub_category_Name 
	order by total_sales desc
    ) as x