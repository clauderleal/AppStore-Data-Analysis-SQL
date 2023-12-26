CREATE TABLE appleStore_description_combined AS

SELECT * from appleStore_description1

UNION ALL

SELECT * from appleStore_description2

UNION ALL 

SELECT * from appleStore_description3

UNION ALL 

SELECT * from appleStore_description4

-- 1# Check the number of unique apps in both tables app store
-- There is no missing data between the tables.

SELECT COUNT(DISTINCT id) as UniqueAppIDs
from AppleStore

Select count(DISTINCT id) as UniqueAppIDs
from appleStore_description_combined

-- 2# Check for any missing values in key fields.
-- There is no missing values.

SELECT count(*) as MissingValues
From AppleStore
WHERE track_name is null or user_rating is null or prime_genre is NULL

SELECT COUNT(*) as MissingValues
from appleStore_description_combined
where app_desc is NULL

-- 3# Find out the number of apps per genre.
-- As we can see the leading apps are the games and entertainment genre.

select prime_genre, count(*) as NumApps
from AppleStore
GROUP by prime_genre
order by NumApps DESC

-- 4# Get an overview of the apps ratings
-- In this query we can see that the minimum rating is zero and maximum is 5 and the average is 3.52

SELECT min(user_rating) as  MinRating,
		max(user_rating) as MaxRating,
        avg(user_rating) as AvgRating
from AppleStore

-- FINDING THE INSIGHTS
-- 5# Determine whether paid apps have higher ratings than free apps.
-- In this query we can assume that paid apps have a slightly higher ratings in compare with the free apps.

SELECT CASE
		when price > 0 then 'Paid'
        else 'Free'
    end as App_Type,
    avg(user_rating) as Avg_Rating
from AppleStore
GROUP by App_Type

-- 6# Check if the apps with more supported languages have higher ratings
-- In this query we can see that we dont need to worry to much in support so many languagues, we can
-- conclude that between 10 and 30 languagues would be the best choice, and we can focus more on other aspects of the app.
select case 
			when lang_num < 10 then 'Less than 10 languages'
            when lang_num BETWEEN 10 and 30 then 'Between 10 and 30 languages'
            else 'More than 30 languages'
       end as language_bucket,
       avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
order by Avg_Rating desc


-- 7# Check genres with low ratings
-- We can see that in Catalogs, Finance and Books category the users gave a bad ratings meaning that they are not satisfied so there might be a good opportunity create an app in these category.

select prime_genre,
		avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC
limit 10

-- 8# Check if there is correlation between the lenght of the app description and the user rating
-- in here we see that the longer the description better is the user rating on average.

SELECT CASE
			when length(b.app_desc) < 500 then 'Short'
            when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
            else 'Long'
         end as description_length_bucket,
         avg(a.user_rating) as average_rating            

from
	AppleStore as A
JOIN
	appleStore_description_combined as b
on
	a.id = b.id
group by description_length_bucket
order by average_rating desc

-- 9# Check the top-rated apps for each genre
-- In this query we will get the top-rated app by each genre

SELECT
	prime_genre,
    track_name,
    user_rating
from (
  	select
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre order by user_rating DESC, rating_count_tot desc) as rank
  		from AppleStore
	  ) as a
where 
a.rank = 1

------------------------ FINAL RECOMMENDATIONS ------------------------------
/* 
1. Paid Apps have better ratings.

Our data analysis has shown that paid apps generally achieve slightly higher ratings than the 
free counterparts so this could be due to a number of reasons so users who pay for an app
may have higher engagement and perceive more value leading to a better ratings. 

2. Apps supporting between 10 and 30 languages have better ratings.

Interestingly our analysis has found that apps supporting a number of languages between
10 and 30 had the highest average rating so we can conclude that it's not just about the quantity of languages
that app can suport, it's more about focus on the right languages to focus.

3. Finance and Books apps have low ratings. 

In our data analysis we have found that there is certain categories that have low users ratings,
and this may suggest that the user needs are not being fully met and so this can represent a market opportunity 
because if we can create a good quality app in these categories that adresses user needs better then the current offer 
there is potential for high user ratings and market penetration. Then we checked the app description 
length and we can conclude that the app description length has a positive correlation with the user ratings 
so the user likely appreciate having a clear understanding of the apps features and capabilities before they 
download the app. So detail well-crafted app description can set clear expectation and eventually increase 
the satisfaction of users. 
We alse seen the target rating in average all the apps have a rating of 3.5, in order to stand out from the crowd 
we should aim for a rating that is higher than the average that is 3.5.
Lastly the games and entertainment category have a very high volume of apps, suggesting that the market 
may be saturated, so entering in these spaces might be challenging due to the high competition however it also 
suggest a high user demand in this sectors.



*/

















