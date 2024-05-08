

-- Q1.How many times does the average user post?

SELECT AVG(post_count) AS average_posts_per_user
FROM (
    SELECT user_id, COUNT(*) AS post_count
    FROM photos
    GROUP BY user_id
) AS user_post_counts;

-- answer. 34730

-- Q2.Find the top 5 most used hashtags.

select tag_name,count(*) as hashtags 
from tags t 
join photo_tags pt 
on t.id = pt.tag_id
group by tag_name
order by hashtags desc
limit 5;

-- answer.'smile','beach''party','fun' and 'concert'

-- Q3.Find users who have liked every single photo on the site.

SELECT users.id,username, count(*) as total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id,username
HAVING total_likes_by_user  = (SELECT COUNT(*) FROM photos);

-- answer. many more users liked every single photo on the site.

-- Q4. Retrieve a list of users along with their usernames and the rank of their account creation, ordered by the creation date in ascending order.

select id,username, created_at, rank() over(order by created_at) as rank_acount_creation
from users;

-- answer. 'Darby_Herzog','Emilio_Bernier52' and 'Elenor88' etc.

-- Q5. List the comments made on photos with their comment texts, photo URLs, and usernames of users who posted the comments. Include the comment count for each photo. 

SELECT 
    p.image_url,
    u.username,
    c.comment_text,
    COUNT(c.id) OVER (PARTITION BY c.photo_id) AS comment_count
FROM comments c
JOIN users u ON c.user_id = u.id
JOIN photos p ON c.photo_id = p.id
ORDER BY p.id;

-- answer. every user comment and text 25 above.

-- Q6. For each tag, show the tag name and the number of photos associated with that tag. Rank the tags by the number of photos in descending order.

SELECT t.tag_name,COUNT(pt.photo_id) AS photo_count
FROM tags t
JOIN photo_tags pt ON t.id = pt.tag_id
GROUP BY t.id, t.tag_name
ORDER BY photo_count DESC;

-- answer. smile,beach,party,fun and many more tag_name.

-- Q7. List the usernames of users who have posted photos along with the count of photos they have posted. Rank them by the number of photos in descending order.

SELECT
    u.username,
    COUNT(p.id) AS photo_count,
    RANK() OVER (ORDER BY COUNT(p.id) DESC) AS user_rank
FROM users u
JOIN photos p ON u.id = p.user_id
GROUP BY u.id, u.username
ORDER BY photo_count DESC;

-- answer. 1 ranked username is 'Eveline95'

-- Q8. Display the username of each user along with the creation date of their first posted photo and the creation date of their next posted photo.
WITH UserPhotoRank AS (
    SELECT
        u.username,
        p.created_at AS first_photo_date,
        LEAD(p.created_at) OVER (PARTITION BY u.id ORDER BY p.created_at) AS next_photo_date,
        ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY p.created_at) AS photo_rank
    FROM users u
    JOIN photos p ON u.id = p.user_id
)

SELECT
    username,
    first_photo_date,
    next_photo_date
FROM UserPhotoRank
WHERE photo_rank = 1;

-- Q9. For each comment, show the comment text, the username of the commenter, and the comment text of the previous comment made on the same photo.
WITH CommentInfo AS (
    SELECT
        c.comment_text,
        u.username AS commenter_username,
        LAG(c.comment_text) OVER (PARTITION BY c.photo_id ORDER BY c.created_at) AS previous_comment_text
    FROM comments c
    JOIN users u ON c.user_id = u.id
)
SELECT
    comment_text,
    commenter_username,
    previous_comment_text
FROM
    CommentInfo;
    
    -- answer. commenter_username- 'Andre_Purdy85'

-- Q10.Show the username of each user along with the number of photos they have posted and the number of photos posted by the user before them and after them, 
-- based on the creation date.

WITH UserPhotoInfo AS (
    SELECT
        u.username,
        COUNT(p.id) AS photo_count,
        LAG(COUNT(p.id)) OVER (ORDER BY MIN(p.created_at)) AS previous_user_photo_count,
        LEAD(COUNT(p.id)) OVER (ORDER BY MIN(p.created_at)) AS next_user_photo_count
    FROM users u
    JOIN photos p ON u.id = p.user_id
    GROUP BY u.id, u.username
)
SELECT
    username,
    photo_count,
    previous_user_photo_count,
    next_user_photo_count
FROM
    UserPhotoInfo
ORDER BY
    username;
