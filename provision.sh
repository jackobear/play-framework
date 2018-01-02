#!/usr/bin/env bash
# This script runs once to build the vm from scratch

export DEBIAN_FRONTEND=noninteractive
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get -y -q install build-essential

# Java
sudo add-apt-repository -y ppa:webupd8team/java
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get update
sudo apt-get -y -q install oracle-java8-installer

# Common stuff, node, scala
sudo apt-get -y install git imagemagick unzip scala nodejs npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
echo "export NODE_PATH=/usr/local/lib/node_modules" >> ~/.bashrc

# Front-end stuff
sudo npm install -g coffee-script
sudo npm install -g bower
sudo apt-get -y install rubygems ruby-all-dev
sudo gem install sass

# Redis
sudo apt-get -y -q install tcl8.5
wget http://download.redis.io/releases/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable
make
make test
sudo make install
sudo ./utils/install_server.sh
cd /home/vagrant/
rm redis-stable.tar.gz

# Postgres
sudo apt-get -y install postgresql postgresql-contrib postgresql-client-common postgresql-common

# SBT (Play Framework's Build tool)
wget http://dl.bintray.com/sbt/debian/sbt-0.13.16.deb
sudo dpkg -i sbt-0.13.16.deb
sudo apt-get update
sudo apt-get install sbt
rm sbt-0.13.16.deb
echo "export SBT_OPTS=\"\$SBT_OPTS -Dsbt.jse.engineType=Node\"" >> ~/.bashrc

# MongoDB
source ~/.bashrc
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get update
sudo apt-get -y install mongodb-org
source ~/.bashrc

# Show Install Summary

echo "jdk version:"
javac -version
echo " "
echo "NodeJS version:"
node -v
echo " "
echo "NPM version"
npm -v
echo " "
echo "CoffeeScript version:"
coffee -v
echo " "
echo "Bower version:"
bower -v
echo " "
echo "Sass version:"
sass -v
echo " "
echo "Redis version"
redis-server -v
echo " "
echo "PostgreSQL version"
psql --version
echo " "
echo "mongoDB version"
mongod --version

# At this point you'd wanna git clone git@github.com:playframework/play-scala-starter-example.git or something similar
# Allow dev host in your app or you'll get a bad request error
# https://www.playframework.com/documentation/2.6.x/AllowedHostsFilter
# Afterwards the app should be available at 10.10.10.130:9000
echo "Allow the dev host in your app by adding 10.10.10.130 to app/conf/application.conf:play.filters.hosts"

