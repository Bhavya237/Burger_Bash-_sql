create database Burger_Case_study;

CREATE TABLE burger_names(
   burger_id   INTEGER  NOT NULL PRIMARY KEY 
  ,burger_name VARCHAR(10) NOT NULL
);
INSERT INTO burger_names(burger_id,burger_name) VALUES (1,'Meatlovers');
INSERT INTO burger_names(burger_id,burger_name) VALUES (2,'Vegetarian');

CREATE TABLE burger_runner(
   runner_id   INTEGER  NOT NULL PRIMARY KEY 
  ,registration_date date NOT NULL
);
INSERT INTO burger_runner VALUES (1,'2021-01-01');
INSERT INTO burger_runner VALUES (2,'2021-01-03');
INSERT INTO burger_runner VALUES (3,'2021-01-08');
INSERT INTO burger_runner VALUES (4,'2021-01-15');

CREATE TABLE runner_ordersS(
   order_id     INTEGER  NOT NULL PRIMARY KEY 
  ,runner_id    INTEGER  NOT NULL
  ,pickup_time  DATETIME
  ,distance     VARCHAR(7)
  ,duration     VARCHAR(10)
  ,cancellation VARCHAR(23)
);

INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (1,1,'2021-01-01 18:15:34','20km','32 minutes',NULL);
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (2,1,'2021-01-01 19:10:54','20km','27 minutes',NULL);
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (3,1,'2021-01-03 00:12:37','13.4km','20 minutes',NULL);
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (4,2,'2021-01-04 13:53:03','23.4','40  minutes',NULL);
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (5,3,'2021-01-08 21:10:57','10','15 minutes',NULL);
INSERT INTO runner_orderss ( order_id,runner_id,pickup_time,distance,duration,cancellation)VALUES (6,3,NULL,NULL,NULL,'Restaurant Cancellation');
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (7,2,'2021-01-08 21:30:45','25km','25minutes',NULL);
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (8,2,'2021-01-10 00:15:02','23.4 km','15 minutes',NULL);
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (9,2,NULL,NULL,NULL,'Customer Cancellation');
INSERT INTO runner_orderss( order_id,runner_id,pickup_time,distance,duration,cancellation) VALUES (10,1,'2021-01-11 18:50:20','10km','10 minutes',NULL);

CREATE TABLE customer_orderss(
   order_id    INTEGER  NOT NULL 
  ,customer_id INTEGER  NOT NULL
  ,burger_id    INTEGER  NOT NULL
  ,exclusions  VARCHAR(4)
  ,extras      VARCHAR(4)
  ,order_time  DATETIME NOT NULL
);
INSERT INTO customer_orderss VALUES (1,101,1,NULL,NULL,'2021-01-01 18:05:02');
INSERT INTO customer_orderss VALUES (2,101,1,NULL,NULL,'2021-01-01 19:00:52');
INSERT INTO customer_orderss VALUES (3,102,1,NULL,NULL,'2021-01-02 23:51:23');
INSERT INTO customer_orderss VALUES (3,102,2,NULL,NULL,'2021-01-02 23:51:23');
INSERT INTO customer_orderss VALUES (4,103,1,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orderss VALUES (4,103,1,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orderss VALUES (4,103,2,'4',NULL,'2021-01-04 13:23:46');
INSERT INTO customer_orderss VALUES (5,104,1,NULL,'1','2021-01-08 21:00:29');
INSERT INTO customer_orderss VALUES (6,101,2,NULL,NULL,'2021-01-08 21:03:13');
INSERT INTO customer_orderss VALUES (7,105,2,NULL,'1','2021-01-08 21:20:29');
INSERT INTO customer_orderss VALUES (8,102,1,NULL,NULL,'2021-01-09 23:54:33');
INSERT INTO customer_orderss VALUES (9,103,1,'4','1, 5','2021-01-10 11:22:59');
INSERT INTO customer_orderss VALUES (10,104,1,NULL,NULL,'2021-01-11 18:34:49');
INSERT INTO customer_orderss VALUES (10,104,1,'2, 6','1, 4','2021-01-11 18:34:49');



select * from burger_names
select * from burger_runner
select * from customer_orderss
select * from runner_ordersS

#Q1. How many burgers were ordered?
select count(burger_id)as no_of_burgers_ordered from runner_ordersS


#Q2. How many unique customer orders were made?
select count (distinct  order_id) from customer_orderss

 
 #Q3. How many successful orders were delivered by each runner?
 select count(order_id) as no_of_successful_orders,runner_id from runner_ordersS
 where cancellation is  null
 group by runner_id

 #Q4. How many of each type of burger was delivered?
 select bn.burger_name,count(co.burger_id)as burgers_delivered 
 from customer_orderss co join 
 runner_ordersS ro on co.order_id=ro.order_id
 join burger_names bn
 on co.burger_id=bn.burger_id
 where ro.cancellation is not null
 group by  bn.burger_name

 #Q5. How many Vegetarian and Meatlovers were ordered by each customer?
 select bn.burger_name,count(bn.burger_id)as burgers_ordered, co.customer_id 
 from customer_orderss co join burger_names bn 
 on co.burger_id=bn.burger_id
 group by co.customer_id,bn.burger_name

 
#Q6. What was the maximum number of burgers delivered in a single order?
select * from customer_orderss
select * from runner_ordersS
with cte as
(select  count(co.burger_id)as burgers_delivered,co.order_id  from customer_orderss co 
join runner_ordersS ro 
on co.order_id=ro.order_id
where cancellation is null
group by co.order_id)
select max(burgers_delivered)as total_burger_delivered from cte


#Q7. For each customer, how many delivered burgers had at least 1 change and how many had no changes?
select co.customer_id,sum(case when co.exclusions=' ' or co.extras =' ' then 1 else 0 end)as atleast_one_change
,sum(case when co.exclusions!=' ' or co.extras! =' ' then 1 else 0 end)as no_change,
count(ro.order_id)as burgers_delivered from customer_orderss co join
runner_ordersS ro on co.order_id=ro.order_id
where cancellation is null
group by co.customer_id

#Q8. What was the total volume of burgers ordered for each hour of the day?
select count(order_id)as burgers_ordered,datepart(hour,order_time)as hour_of_day from customer_orderss
group by datepart(hour,order_time)

#Q9. How many runners signed up for each 1 week period? 
select datepart(week , registration_date) as regis_week,
       count(runner_id) as runner_signup
    from burger_runner
group by datepart(week , registration_date)

#Q10. What was the average distance travelled for each customer?
select avg(ro.distance)as average_distance_travelled,co.customer_id from runner_ordersS ro join 
customer_orderss co on ro.order_id=co.order_id
where distance != null
group by co.customer_id