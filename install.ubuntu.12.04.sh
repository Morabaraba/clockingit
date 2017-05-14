# #!/bin/bash

# ClockingIT v0.99.3: TimeTracking 2.0
# Created by Erlend & Ellen Simonsen, with contributors.
# MIT/X11 license
# Only for Ubuntu 12.04 LTS(debian).
# You need to run it as `root`.
# ==============================================================
CURRENT_DIR=`pwd`
SCRIPT_DIR="$(dirname "$0")"

echo "Update and Upgrade our System..."
apt-get update && apt-get upgrade

echo "Install needed packages from distro..."
apt-get install mysql-server mysql-client libmysqlclient-dev \
graphicsmagick-libmagick-dev-compat imagemagick ruby1.8 ruby1.8-dev rubygems ri rdoc rake librmagick-ruby \
apache2 -y

echo "Apache ServerName(eg, *.clockingit.com):
read $SERVERNAME
echo "Create cit database, mysql root password needed..."
echo "CREATE DATABASE cit DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL ON cit.* TO 'cit'@'localhost' IDENTIFIED BY 'cit'; FLUSH PRIVILEGES;" | mysql -u root -p

echo "Install needed ruby gems..."
gem install json -v 1.8.6 -r
gem install json_pure -v 2.0.1 -r
gem install rdoc -v 4.2.2 -r
gem install rake -v 10.4.2 -r
gem install gchartrb RedCloth tzinfo echoe fastercsv test-spec ferret hoe mongrel eventmachine -r
# To lazy now but we will need this in the future:
# gchartrb-0.8
# RedCloth-4.3.2
# tzinfo-1.2.3
# echoe-4.6.6
# fastercsv-1.5.5
# test-spec-0.10.0
# ferret-0.11.8.7
# hoe-3.16.0
# mongrel-1.1.5
# eventmachine-1.2.3
gem install ZenTest -v 4.1.4 -r
gem install icalendar -v 1.1.0 -r
gem install mysql -v 2.7 -r


echo "Moving cit directory to /opt/cit..."
cd $SCRIPT_DIR
mv cit /opt/.
cd /opt/cit
mkdir log

echo "Setup ruby app..."
ruby setup.rb

echo "Change permission(777)..."
chmod 777 /opt/cit -Rf

echo "Enable Apache rewrite..."
a2enmod rewrite

echo "OVERWRITE!?1 default apache config..."
echo "<VirtualHost *:80>
    ServerName $SERVERNAME
    DocumentRoot /opt/cit/public/
    ErrorLog /opt/cit/log/http.log

    <Directory /opt/cit/public/>
      Options ExecCGI FollowSymLinks
      AllowOverride all
      Allow from all
      Order allow,deny
    </Directory>
  </VirtualHost>" > /etc/apache2/sites-available/default

echo "Restart apache2..."
/etc/init.d/apache2 restart

echo "Copy init.d script..."
cp cit /etc/init.d/cit

echo "Change permission(+x)..."
chmod +x /etc/init.d/cit
echo "Update init.d script..."
sed -i 's/CHANGE_CIT_PATH/\/opt\/cit/g' -i /etc/init.d/cit
echo "Done! See /opt/cit/config/environment.rb-example and /opt/cit/config/database.yml-example to setup your env."
echo "Start ClockingIT with /etc/init.d/cit start"
