sudo apt-get update -y
sudo apt-get install curl -y
sudo apt-get install vim -y
sudo apt-get install openjdk-6-jdk -y

# Set up MySQL
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password password'
sudo apt-get install mysql-server-5.5 -y

if [ ! -f /var/log/databasesetup ];
then
    echo "CREATE DATABASE mahout" | mysql -uroot -ppassword

    if [ -f /home/vagrant/vm-shared/mysql/create-table.sql ];
    then
        mysql -uroot -ppassword mahout < /home/vagrant/vm-shared/mysql/create-table.sql
    fi

    if [ -f /home/vagrant/vm-shared/mysql/insert-data.sql ];
    then
    	sudo cp /home/vagrant/vm-shared/mysql/activity-trail-data.csv /var/lib/mysql/mahout
        mysql -uroot -ppassword mahout < /home/vagrant/vm-shared/mysql/insert-data.sql
    fi

    touch /var/log/databasesetup
fi

# Set Up Hadoop
sudo curl https://www.apache.org/dist/hadoop/core/hadoop-1.2.1/hadoop-1.2.1-bin.tar.gz | sudo tar xvz -C /usr/local
sudo mv /usr/local/hadoop-1.2.1 /usr/local/hadoop

sudo curl http://www.apache.org/dist/mahout/0.7/mahout-distribution-0.7.tar.gz | sudo tar xvz -C /usr/local
sudo mv /usr/local/mahout-distribution-0.7 /usr/local/mahout

sudo curl http://www.apache.org/dist/sqoop/1.4.4/sqoop-1.4.4.bin__hadoop-1.0.0.tar.gz | sudo tar xvz -C /usr/local
sudo mv /usr/local/sqoop-1.4.4.bin__hadoop-1.0.0 /usr/local/sqoop
sudo cp /home/vagrant/vm-shared/mysql/mysql-connector-java-5.1.27-bin.jar /usr/local/sqoop/lib

sudo cp -fR /home/vagrant/vm-shared/hadoop/hadoop-env.sh /usr/local/hadoop/conf
sudo cp -fR /home/vagrant/vm-shared/hadoop/core-site.xml /usr/local/hadoop/conf
sudo cp -fR /home/vagrant/vm-shared/hadoop/mapred-site.xml /usr/local/hadoop/conf
sudo cp -fR /home/vagrant/vm-shared/hadoop/hdfs-site.xml /usr/local/hadoop/conf

sudo cp -fR /home/vagrant/vm-shared/.bashrc /home/vagrant

# Set up hadoop ssh keys and permissions
mkdir -p /home/vagrant/.ssh
ssh-keygen -t rsa -P "" -f "/home/vagrant/.ssh/id_rsa"
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

sudo chown -R vagrant:vagrant /home/vagrant/.ssh

sudo chown -R vagrant:vagrant /usr/local/hadoop
sudo chown -R vagrant:vagrant /usr/local/mahout
sudo chown -R vagrant:vagrant /usr/local/sqoop

sudo mkdir -p /app/hadoop/tmp
sudo chown vagrant:vagrant /app/hadoop/tmp


su vagrant -c '/usr/local/hadoop/bin/hadoop namenode -format'
