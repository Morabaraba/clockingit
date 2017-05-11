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

echo "Create cit database, mysql root password needed..."
echo "CREATE DATABASE cit DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci; GRANT ALL ON cit.* TO 'cit'@'localhost' IDENTIFIED BY 'cit'; FLUSH PRIVILEGES;" | mysql -u root -p

echo "Install needed ruby gems..."
gem install gchartrb RedCloth json tzinfo echoe fastercsv test-spec ferret hoe mongrel eventmachine -r
gem install ZenTest -v 4.1.4 -r
gem install icalendar -v 1.1.0 -r
gem install mysql -v 2.7 -r

echo "Moving cit directory to /opt/cit..."
cd $SCRIPT_DIR
mv cit /opt/.
cd /opt/cit
echo "Create log directory..."
mkdir -p log

echo "Setup ruby app..."
ruby setup.rb

echo "Change permission(777)..."
chmod 777 /opt/cit -Rf

echo "Enable Apache rewrite..."
a2enmod rewrite

echo "OVERWRITE!?1 default apache config..."
echo "<VirtualHost *:80>
    ServerName localhost
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
echo "Start ClockingIT..."
/etc/init.d/cit start
echo "Done! Open http://localhost:80 in your browser."
