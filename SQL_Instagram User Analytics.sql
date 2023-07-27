/* 
Instagram User Analysis

Skills used - Joins, Aggregation, Temporary Table, Aliasing,
				Date Function
*/

-- Q1 :- 5 oldest users of Instagram
SELECT * 
FROM users
ORDER BY created_at ASC
LIMIT 5;

-- Q2 :- Users who have never posted a single video
SELECT photos.image_url, users.id, users.username
FROM photos
RIGHT JOIN users
	ON photos.user_id = users.id 
WHERE image_url IS NULL
GROUP BY users.id;

-- Q3 :- Identify the winner of the contest
SELECT
users.username, 
photos.user_id,
photo_id,
COUNT(DISTINCT likes.user_id) AS Number_of_likes
FROM ig_clone.likes
LEFT JOIN photos
	ON (likes.photo_id = photos.id)
    LEFT JOIN users
		ON ( photos.user_id = users.id)
GROUP BY photo_id
ORDER BY Number_of_likes DESC
LIMIT 1 ;

-- Q4 :- Top 5 most commonly used hastags
SELECT 
tag_id,
tags.tag_name,
COUNT(DISTINCT photo_id) AS Number_of_occurance  
FROM photo_tags
LEFT JOIN tags
	ON photo_tags.tag_id = tags.id
GROUP BY tag_id
ORDER BY Number_of_occurance DESC
LIMIT 5;

-- Q5 :- Day of the week most users register on
SELECT
COUNT(DISTINCT username) AS total_users, 
dayofweek(created_at) AS week_day
FROM ig_clone.users
GROUP BY week_day
ORDER BY total_users DESC ;

-- Q6 :- Number of times avg user posts on instagram
-- & Total number of photos/ total number of users
CREATE TEMPORARY TABLE Frequency
SELECT 
COUNT(DISTINCT id) AS user_posts,
user_id
FROM ig_clone.photos
GROUP BY user_id;

SELECT AVG(user_posts) AS Avg_user_posts
FROM Frequency;

SELECT 
SUM(id)/SUM(DISTINCT user_id) AS `total photos/total users`
FROM ig_clone.photos;

-- Q7 :- Users(bots) who liked every single photo
SELECT
users.username,
user_id ,
COUNT(DISTINCT photo_id) AS Likes
FROM ig_clone.likes
LEFT JOIN users
	ON(likes.user_id = users.id)  
GROUP BY user_id
HAVING Likes = 257;
