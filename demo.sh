# password for vagrant user and root is 'vagrant'

# Start Hadoop Name Node, Job Tracker, etc.
/usr/local/hadoop/bin/start-all.sh
# Say "yes" if this asks if you want to continue

mysql -uroot -ppassword mahout
	SELECT * FROM activity_trail;
	exit


# Sqoop MySQL Activity Trail data to HDFS
/usr/local/sqoop/bin/sqoop import --username root --password password --connect 'jdbc:mysql://localhost/mahout' --table activity_trail --columns target_url,user_id --where "target_url LIKE '/prospects/profile/%' AND user_id IS NOT NULL" --target-dir /home/vagrant/activity-trail-sql-import --split-by user_id

# View Output
hadoop fs -ls /home/vagrant/activity-trail-sql-import
hadoop fs -cat /home/vagrant/activity-trail-sql-import/part-m-00000
# if error
# hadoop dfsadmin -safemode leave


# Count profile clicks per user
hadoop jar /usr/local/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/vagrant/vm-shared/mapreduce/profile-clicks-per-user-mapper.py    -mapper /home/vagrant/vm-shared/mapreduce/profile-clicks-per-user-mapper.py \
-file /home/vagrant/vm-shared/mapreduce/profile-clicks-per-user-reducer.py  -reducer /home/vagrant/vm-shared/mapreduce/profile-clicks-per-user-reducer.py \
-input /home/vagrant/activity-trail-sql-import/* -output /home/vagrant/profile-clicks-per-user

hadoop fs -ls /home/vagrant/profile-clicks-per-user
hadoop fs -cat /home/vagrant/profile-clicks-per-user/part-00000


# Run Mahout
hadoop jar /usr/local/mahout/mahout-core-0.7-job.jar org.apache.mahout.cf.taste.hadoop.item.RecommenderJob -s SIMILARITY_COOCCURRENCE --input /home/vagrant/profile-clicks-per-user/* --output /home/vagrant/mahout-output
# this one takes a while
# if error
# hadoop fs -rmr /user/vagrant/temp

# View Output 
hadoop fs -ls /home/vagrant/mahout-output
hadoop fs -cat /home/vagrant/mahout-output/part-r-00000


# Clean Data for Sqoop import back to MySQL
hadoop jar /usr/local/hadoop/contrib/streaming/hadoop-*streaming*.jar \
-file /home/vagrant/vm-shared/mapreduce/sql-output-format-mapper.py    -mapper /home/vagrant/vm-shared/mapreduce/sql-output-format-mapper.py \
-file /home/vagrant/vm-shared/mapreduce/sql-output-format-reducer.py  -reducer /home/vagrant/vm-shared/mapreduce/sql-output-format-reducer.py \
-input /home/vagrant/mahout-output/* -output /home/vagrant/mahout-preference-cleaned-sql-export

# View Output 
hadoop fs -ls /home/vagrant/mahout-preference-cleaned-sql-export
hadoop fs -cat /home/vagrant/mahout-preference-cleaned-sql-export/part-00000

# Sqoop Result back to MySQL
/usr/local/sqoop/bin/sqoop export --username root --password password --connect 'jdbc:mysql://localhost/mahout' --table mahout_preference --export-dir /home/vagrant/mahout-preference-cleaned-sql-export

# View Output
mysql -uroot -ppassword mahout
	SELECT * FROM mahout_preference;
	exit



# Cleanup 
hadoop fs -rmr /home/vagrant/activity-trail-sql-import
hadoop fs -rmr /home/vagrant/profile-clicks-per-user
hadoop fs -rmr /home/vagrant/mahout-output
hadoop fs -rmr /home/vagrant/mahout-preference-cleaned-sql-export

hadoop fs -rmr /user/vagrant/temp

mysql -uroot -ppassword mahout
	DELETE FROM mahout_preference;
	exit

