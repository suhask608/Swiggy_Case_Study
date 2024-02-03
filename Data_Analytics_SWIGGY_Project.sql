use SWIGGY;
select * from swiggy;

#01 HOW MANY RESTAURANTS HAVE A RATING GREATER THAN 4.5?
SELECT COUNT(DISTINCT restaurant_name) AS High_Rated_Restaurants FROM SWIGGY 
WHERE RATING > 4.5;

#02 WHICH IS THE TOP 1 CITY WITH THE HIGHEST NUMBER OF RESTAURANTS?
select  city, count(DISTINCT restaurant_name) as Restaurants_count  from swiggy
group by city
order by Restaurants_count desc limit 1;

#03 HOW MANY RESTAURANTS SELL( HAVE WORD "PIZZA" IN THEIR NAME)?
select count(Distinct RESTAURANT_name) from swiggy
where RESTAURANT_name LIKE "%PIZZA%";

#04 WHAT IS THE MOST COMMON CUISINE AMONG THE RESTAURANTS IN THE DATASET?
select cuisine, count(*) as cuisine_count
from swiggy
group by cuisine
order by cuisine_count desc limit 1;

#05 WHAT IS THE AVERAGE RATING OF RESTAURANTS IN EACH CITY?
select city, avg(rating) AS AVG_RATING
from swiggy
group by city;

#06 WHAT IS THE HIGHEST PRICE OF ITEM UNDER THE 'RECOMMENDED' MENU CATEGORY FOR EACH RESTAURANT?
select  Distinct RESTAURANT_name, menu_category, max(price) AS Highest_Price
from swiggy
where menu_category="RECOMMENDED"
group by RESTAURANT_name, menu_category;

#07 FIND THE TOP 5 MOST EXPENSIVE RESTAURANTS THAT OFFER CUISINE OTHER THAN INDIAN CUISINE. 
select Distinct RESTAURANT_name, cost_per_person
from swiggy
where cuisine <> "Indian"
order by cost_per_person desc limit 5;

#08 FIND THE RESTAURANTS THAT HAVE AN AVERAGE COST WHICH IS HIGHER THAN THE TOTAL AVERAGE COST OF ALL RESTAURANTS TOGETHER.
select Distinct RESTAURANT_name, cost_per_person from swiggy where cost_per_person >(
select avg(cost_per_person) as Avg_cost_per_person
from swiggy);

#09 RETRIEVE THE DETAILS OF RESTAURANTS THAT HAVE THE SAME NAME BUT ARE LOCATED IN DIFFERENT CITIES.
select distinct s1.RESTAURANT_name, s1.city, s2.city 
from swiggy s1 join swiggy s2
ON s1.RESTAURANT_name = s2.RESTAURANT_name AND s1.city <> s2.city;

#10 WHICH RESTAURANT OFFERS THE MOST NUMBER OF ITEMS IN THE 'MAIN COURSE' CATEGORY?
select distinct RESTAURANT_name, count(item) as Items_count, menu_category
from swiggy
where menu_category = "Main course"
group by RESTAURANT_name
order by Items_count desc limit 1;

#11 LIST THE NAMES OF RESTAURANTS THAT ARE 100% VEGEATARIAN IN ALPHABETICAL ORDER OF RESTAURANT NAME
select distinct restaurant_name,
(count(case when veg_or_nonveg='Veg' then 1 end)*100/
count(*)) as vegetarian_percetage
from swiggy
group by restaurant_name
having vegetarian_percetage=100
order by restaurant_name;

#12 WHICH IS THE RESTAURANT PROVIDING THE LOWEST AVERAGE PRICE FOR ALL ITEMS?
select distinct RESTAURANT_name, avg(price) as Avg_Price
from swiggy
group by RESTAURANT_name
order by Avg_Price limit 1;

#13 WHICH TOP 5 RESTAURANT OFFERS HIGHEST NUMBER OF CATEGORIES?
select distinct RESTAURANT_name, count(distinct menu_category) as No_of_Category
from swiggy
group by RESTAURANT_name
order by No_of_Category desc limit 5;

#14 WHICH RESTAURANT PROVIDES THE HIGHEST PERCENTAGE OF NON-VEGEATARIAN FOOD?
select distinct RESTAURANT_name, 
(count(CASE WHEN veg_or_nonveg = "Non-veg" then 1 end)*100/count(*)) as non_veg_percentage
from swiggy
group by RESTAURANT_name
order by non_veg_percentage desc limit 1;

#15 Determine the Most Expensive and Least Expensive Cities for Dining:
With City_expense as
(
select city, max(cost_per_person) as Most_expensive, min(cost_per_person) as Least_expensive from swiggy
group by city
)
select city, Most_expensive, Least_expensive
from City_expense;

#16 Calculate the Rating Rank for Each Restaurant Within Its City
With Rank_of_Restaurant as
(
select DISTINCT RESTAURANT_name, city, rating,
dense_rank() over(partition by city order by rating desc) as highest_rating_Restaurant
from swiggy
)
select RESTAURANT_name, city, rating, highest_rating_Restaurant from Rank_of_Restaurant
where highest_rating_Restaurant=1;

