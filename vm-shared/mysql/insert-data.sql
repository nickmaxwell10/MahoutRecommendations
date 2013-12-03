load data infile 'activity-trail-data.csv' into table activity_trail
fields terminated by ','
enclosed by '"'
lines terminated by '\r'
(user_id, target_url)