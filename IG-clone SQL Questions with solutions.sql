/* We want to reward the user who has been around the longest, Find the 5 oldest users.*/

select * from users 
order by created_at limit 5;

/* To understand when to run the ad campaign, figure out the day of the week most users register on.*/

select count(username) as No_OfUsers, dayname(created_at) as DaysOfWeek
from users 
group by DaysOfWeek
order by No_OfUsers desc;

/* To target inactive users in an email ad campaign, find the users who have never posted a photo.*/

select u.id, username
from users u left outer join photos p
on u.id = p.user_id
where user_id is null
group by username;

/* Suppose you are running a contest to find out who got the most likes on a photo. Find out who won */

select u.id, username, l.photo_id, count(l.photo_id) as Likes
from users u join photos p
on u.id = p.id join likes l
on p.id = l.photo_id
group by username
order by Likes desc;

/* The investors want to know how many times does the average user post.*/

create view Users_Post as
select user_id, count(comment_text) as Post
from comments 
group by user_id
union all
select user_id, count(image_url)
from photos
group by user_id;  # View created to Perform the following operation.

select avg(Post_count) from ( select 
count(*) as post_count from users_post
group by user_id) as count_Post;

/* A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.*/

select tag_name as Hashtags, count(tag_id) as Most_usedTags
from tags t join photo_tags pt
on t.id = pt.tag_id
group by tag_name
order by Most_usedTags desc limit 5;

/* To find out if there are bots, find users who have liked every single photo on the site.*/

select id, username
from users where id in ( select distinct
user_id from photos);


/* To know who the celebrities are, find users who have never commented on a photo.*/

select id, username
from users where id not in ( select
distinct user_id from comments);

/* Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.*/

select id, username
from users where id not in ( select
distinct user_id from comments) or id in ( select distinct
user_id from comments);