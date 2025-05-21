create database project3;



#creating table1#
create table `users` (
`user_id` INT ,
`created_at` VARCHAR(100),
`company_id` INT,
`language` VARCHAR(50),
`activated_at` VARCHAR(100),
`state` VARCHAR(50)
);

 
SHOW VARIABLES LIKE 'secure_file_priv';
set global local_infile =1; 


load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users.csv'
into table `users`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`user_id`,`created_at`,`company_id`,`language`,`activated_at`,`state`);

select count(*) from users;

SET SQL_SAFE_UPDATES = 0;

#updating the cretaed_at column from varchar to date datatype#
alter table users add column temp_created_at  datetime;
update users set temp_created_at = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;


#updating the activated_at column from varchar to date datatype#
alter table users add column temp_activated_at  datetime;
update users set temp_activated_at = STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i');
alter table users drop column activated_at;
alter table users change column temp_activated_at activated_at datetime;

select * from users;

----------------------------------------------------------------------------------------------------


#creating table2#
create table `events` (
`user_id` INT ,
`occurred_at` VARCHAR(100),
`event_type` VARCHAR(50),
`event_name` VARCHAR(50),
`location` VARCHAR(100),
`device` VARCHAR(50),
`user_type` INT
);



load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\events.csv'
into table `events`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`user_id`,`occurred_at`,`event_type`,`event_name`,`location`,`device`,`user_type`);

select count(*) from `events`;

SET SQL_SAFE_UPDATES = 0;

#updating the cretaed_at column from varchar to date datatype#
alter table `events` add column temp_occurred_at  datetime;
update `events` set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table `events` drop column occurred_at;
alter table `events` change column temp_occurred_at occurred_at datetime;

select * from `events`;




------------------------------------------------------------------------------------------------------------------------------------



#creating table3#

create table `email_events` (
`user_id` INT ,
`occurred_at` VARCHAR(100),
`action` VARCHAR(100),
`user_type` INT
);


load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\email_events.csv'
into table `email_events`
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(`user_id`,`occurred_at`,`action`,`user_type`);



select count(*) from `email_events`;

SET SQL_SAFE_UPDATES = 0;

#updating the cretaed_at column from varchar to date datatype#
alter table `email_events` add column temp_occurred_at  datetime;
update `email_events` set temp_occurred_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');
alter table `email_events` drop column occurred_at;
alter table `email_events` change column temp_occurred_at occurred_at datetime;

select * from `email_events`;



------------------------------------------------------------------------------------------------------------------------------------

#(1) Measure the activeness of users on a weekly basis#

SELECT 
    YEARWEEK(occurred_at, 1) AS `week`,  
    user_id,
    COUNT(*) AS weekly_events  
FROM events
GROUP BY user_id, `week`
ORDER BY `user_id`;

------------------------------------------------------------------------------------------------------------------------------------

#(2) Calculate user growth over time #

SELECT 
    YEARWEEK(created_at, 1) AS week,
    COUNT(user_id) AS new_users
FROM users
GROUP BY week
ORDER BY week;


---------------------------------------------------------------------------------------------------------------


#(3) Calculate weekly retention based on signup cohorts.

SELECT 
    YEARWEEK(u.created_at, 1) AS signup_week,
    COUNT(DISTINCT e.user_id) AS retained_users
FROM users u
JOIN events e ON u.user_id = e.user_id
GROUP BY signup_week



--------------------------------------------------------------------------------------------------

# Measure activeness of users on a weekly basis per device.#

SELECT 
    YEARWEEK(occurred_at, 1) AS `week`,
    device,
    COUNT(DISTINCT user_id) AS active_users
FROM events
GROUP BY `week`, device
ORDER BY `week`;


----------------------------------------------------------------------------------------------------

#Calculate email engagement metrics.#

SELECT 
    YEARWEEK(occurred_at, 1) AS week,
    COUNT(*) AS emails_sent,
    COUNT(CASE WHEN `action` = 'email_clickthrough' THEN 1 ELSE NULL END) AS email_clickthrough,
    COUNT(CASE WHEN `action` = 'email_open' THEN 1 ELSE NULL END) AS email_open,
	COUNT(CASE WHEN `action` = 'sent_reengagement_email' THEN 1 ELSE NULL END) AS sent_reengagement_email,
	COUNT(CASE WHEN `action` = 'sent_weekly_digest' THEN 1 ELSE NULL END) AS sent_weekly_digest
FROM email_events
GROUP BY week
ORDER BY week;