#!/bin/bash
set -e

 
install_all() {
    echo "Initalizing MySQL..."
 #   mysqld --initialize --user=mysql
    chown -R mysql:mysql /var/lib/mysql
    /usr/bin/mysqld_safe &
    sleep 1
    mysql -uroot -proot -e "CREATE DATABASE netshot01 CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
    mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON netshot01.* TO 'netshot'@'localhost' IDENTIFIED BY 'netshot'; FLUSH PRIVILEGES;"
  #   mysql -uroot -proot -e "INSERT INTO netshot01.user VALUES (1000, b'1','netshot','7htrot2BNjUV/g57h/HJ/C1N0Fqrj+QQ');"
mysql -u root -proot <<MYSQL_SCRIPT
CREATE TABLE netshot01.user (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  hashed_password varchar(255) DEFAULT NULL,
  level int(11) NOT NULL,
  local bit(1) NOT NULL,
  username varchar(255) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY UK_t8tbwelrnviudxdaggwr1kd9b (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
MYSQL_SCRIPT
 
  mysql -uroot -proot -e "INSERT INTO netshot01.user VALUES (1,'7htrot2BNjUV/g57h/HJ/C1N0Fqrj+QQ',1000, b'1','netshot');"
   killall mysqld
    sleep 1
    echo "Installing NETSHOT..."
    #mkdir -p /usr/local/netshot/drivers
    #chown -R netshot /usr/local/netshot
    adduser --system --home /usr/local/netshot --disabled-password --disabled-login netshot
    keytool -genkey -noprompt -keyalg RSA -alias selfsigned -keystore netshot.jks -storepass password -keypass password -validity 3600 -keysize 2048 -dname "cn=nettool, ou=nettool, o=nettool, c=FR"
    mv netshot.jks /usr/local/netshot
    chmod o-r /usr/local/netshot
    mkdir /var/log/netshot
    mkdir -p /usr/local/netshot/drivers
    chown -R netshot /var/log/netshot
    chown netshot  /usr/local/netshot/netshot.conf
    chmod 777 /usr/local/netshot/netshot.conf
}
mysql_start() {
    echo "Start Mysql"
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
    /usr/bin/mysqld_safe
}

case "$1" in
  "-install")
    install_all
    ;;
  "-start")
    mysql_start
    ;;
  *)
    echo "Please specify one of the following switches when launching this script:"
    echo "-install used to initalize the tables"
    echo "-run used for inside supervisord "
    exit 1
    ;;
esac
