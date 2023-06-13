USE ig_app;
-- 1 最早註冊的五位使用者
select * from users order by created_at limit 5 ;

-- 2 因為要辦一個線上活動，因此想要找一個一周裡面大眾喜歡嘗試新事物的時間，請找出一個禮拜中，最多人註冊的是禮拜幾?  
select * from users;

select dayname(created_at), count(*) as total 
from users
group by dayname(created_at)
order by total desc;

-- 3 為了提高APP使用率，請找出沒有發過照片的使用者名稱(username)，拿到資料後會請專員聯絡給他們
select username
from users
left join photos
on users.id = photos.user_id
where photos.user_id is null;


select *
from users
left join photos
on users.id = photos.user_id;

-- 4 想要頒獎給社群內拿到最多讚照片，並查詢出那個是誰(username)的照片。
-- 先用 likes table 找出最多讚的照片
select * from likes;


select photo_id, count(*) from likes
group by photo_id
order by count(*) desc
limit 1;

select photo_id from likes
group by photo_id
order by count(*) desc
limit 1;

select photos.id, username
from photos
join users
on users.id =  photos.user_id
where photos.id = (select photo_id from likes
group by photo_id
order by count(*) desc
limit 1);


-- 5. 請根據上題寫出一個預存程序，名稱自訂(越清楚越好)
DELIMITER //
CREATE PROCEDURE most_popular_photo()
begin
select photos.id, username
from photos
join users
on users.id =  photos.user_id
where photos.id = (select photo_id from likes
group by photo_id
order by count(*) desc
limit 1);
end //

DELIMITER ;

drop procedure most_popular_photo;
call most_popular_photo();

-- 6 一個名牌想要打廣告，於是想要知道目前前五名#tag次數最多的主題。
-- 先找photo_tags(table)裡的tag_id並算出tag次數然後依照tag的次數由多到少的排列
-- 再找photo_tags(table)裡的tag_name和他tag的次數一樣由多到少的排列
select tag_id, count(*)
from photo_tags
group by tag_id
order by count(*) desc
limit 5;

-- mysql 本版本的 subquery 不支援 limit (what...) 
select tag_name
from photo_tags
join tags
on tags.id = photo_tags.tag_id
where tag_name in (select tag_id
from photo_tags
group by tag_id0
order by count(*) desc
limit 5);

-- 改成先 join 再 group by
select tag_name, count(*)
from photo_tags
join tags
on photo_tags.tag_id = tags.id
group by tag_name
order by count(*) desc
limit 7;


-- 7. IT團隊發現有機器人假帳號在每一張照片按讚，請找出這些假帳號。
select count(*) from photos;


select likes.user_id, count(*) as total
from users
join likes
on users.id = likes.user_id
group by likes.user_id
having total = (select count(*) from photos);

select username, count(*) as total
from users
join likes
on users.id = likes.user_id
group by username
having total = (select count(*) from photos);

-- 8 請計算使用者上傳照片的平均數(總體)
select count(*) from photos;
select count(*) from users;


select 
(select count(*) from photos) 
/ (select count(*) from users)
as '平均數';
