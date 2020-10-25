![Ironhack logo](https://i.imgur.com/1QgrNNw.png)

# Lab | My first queries

Please, import the .csv database called *AppleStore.csv*. Use the *data* table to query the data about Apple Store Apps and answer the following questions: 

**1. Which are the different genres?**

select prime_genre
from appstore.applestore

**2. Which is the genre with more apps rated?**

select prime_genre,rating_count_tot
from appstore.applestore
order by rating_count_tot desc
limit 3

**3. Which is the genre with more apps?**

select prime_genre,count(prime_genre) as total
from appstore.applestore
group by prime_genre
order by total desc
limit 4


**4. Which is the one with less?**

select prime_genre,count(prime_genre) as total
from appstore.applestore
group by prime_genre
order by total asc
limit 4


**5. Take the 10 apps most rated.**

select rating_count_tot,track_name
from appstore.applestore
group by track_name
order by rating_count_tot desc
limit 10


**6. Take the 10 apps best rated by users.**

select user_rating,track_name,rating_count_tot
from appstore.applestore
where user_rating= '5'
group by track_name
order by rating_count_tot desc 
limit 10

**7. Take a look on the data you retrieved in the question 5. Give some insights.**

We can see from exercice 5 social platforms are the most rated app,followed by gaming platforms.


**8. Take a look on the data you retrieved in the question 6. Give some insights.**

The 10 best rated apps by users are games

**9. Now compare the data from questions 5 and 6. What do you see?**

The most ratings are for social media and the best ratings are for games

**10. How could you take the top 3 regarding the user ratings but also the number of votes?**

select user_rating,track_name,rating_count_tot
from appstore.applestore
group by track_name
order by rating_count_tot desc 
limit 3

**11. Does people care about the price?** Do some queries, comment why are you doing them and the results you retrieve. What is your conclusion?


select track_name,price,rating_count_tot
from appstore.applestore
where price > 10
group by price
order by rating_count_tot desc

select count(price) 
from appstore.applestore
where price > '10'
#existem 89 applicacoes que custam mais de 10 euros

select sum(rating_count_tot),price
from appstore.applestore
where price > '10'

There is 65105 users that bought apps that cost more than 10 euros and reviewed it, it means that if user spend 10 euros in app they can spend even 100, it means that users that spend more than 10 euros don't care about the price.

## Deliverables 
You need to submit a `.sql` file that includes the queries used to answer the questions above, as well as an `.md` file including your answers. 
