#!/usr/bin/env bash

# http://www.slideshare.net/sickill/chef-or-how-to-make-computers-do-the-work-for-us
# https://github.com/LunarLogicPolska/lunar-station
# https://github.com/rudyl313/rails-cookbook
# http://teohm.github.io/blog/2013/04/17/chef-cookbooks-for-busy-ruby-developers

RUBY_VERSION='ruby-1.9.3-p392'
MYSQL_SERVER_VERSION='5.5'

MYSQL_USER='root'
MYSQL_PASSWORD='root'

POSTGRES_USER='postgres'
POSTGRES_PASSWORD='postgres'

APP_USER='rails_app_tmpl'
APP_HOME='/vagrant/rails_app_tmpl'

TEST_DB_SCHEMA='rails_app_tmpl_test'
DEV_DB_SCHEMA='rails_app_tmpl_dev'
PROD_DB_SCHEMA='rails_app_tmpl_prod'

apt-get update

sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y subversion


curl -L https://www.opscode.com/chef/install.sh | sudo bash
sudo cp -R /opt/chef /var
sudo chown -R vagrant /var/chef
sudo rm -rf /opt/chef


\curl -L https://get.rvm.io |
  bash -s stable --ruby=$RUBY_VERSION --autolibs=enable --auto-dotfiles

chown -R vagrant /usr/local/rvm
chown -R vagrant /opt/vagrant_ruby

cd /home/vagrant
source /usr/local/rvm/scripts/rvm

sudo apt-get install -y postgresql-client
sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql

sudo usermod --password $POSTGRES_USER $POSTGRES_PASSWORD

sudo -u postgres psql -c "CREATE USER $APP_USER WITH PASSWORD '$APP_USER'"

ENCODING_STRING="WITH ENCODING = 'UTF-8' LC_CTYPE = 'en_US.utf8' LC_COLLATE = 'en_US.utf8' OWNER $POSTGRES_USER TEMPLATE template0"

sudo -u postgres psql -c "CREATE DATABASE $DEV_DB_SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DEV_DB_SCHEMA to $APP_USER"

sudo -u postgres psql -c "CREATE DATABASE $TEST_DB_SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $TEST_DB_SCHEMA to $APP_USER"

sudo -u postgres psql -c "CREATE DATABASE $PROD_DB_SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PROD_DB_SCHEMA to $APP_USER"

sudo apt-get install -y libmysqlclient-dev ruby-dev

sudo apt-get install debconf-utils
sudo apt-get install -y mysql-client

sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password password $MYSQL_PASSWORD"
sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password_again password $MYSQL_PASSWORD"

apt-get -y install mysql-server

mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "CREATE USER '$APP_USER'@'localhost' IDENTIFIED BY '$APP_USER';"

mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "grant all privileges on *.* to '$APP_USER'@'localhost' identified by '$APP_USER' with grant option;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"

mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $TEST_DB_SCHEMA;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $DEV_DB_SCHEMA;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $PROD_DB_SCHEMA;"

cd $APP_HOME

bundle install --without=production

# rake db:migrate
# rails s