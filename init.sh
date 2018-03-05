#!/bin/bash
set -e
install_all() {
	echo "Initalizing MySQL..."
		chown -R mysql:mysql /var/lib/mysql
		/usr/bin/mysqld_safe &
		sleep 1
		mysql -uroot -proot < /tmp/db.sql
		killall mysqld
		sleep 1
		echo "Installing NETSHOT..."
		adduser --system --home /usr/local/netshot --disabled-password --disabled-login netshot
		keytool -genkey -noprompt -keyalg RSA -alias selfsigned -keystore netshot.jks -storepass password -keypass password -validity 3600 -keysize 2048 -dname "cn=nettool, ou=nettool, o=nettool, c=FR"
		mv netshot.jks /usr/local/netshot
		mkdir /var/log/netshot
		mkdir -p /usr/local/netshot/drivers
		chown -R netshot /var/log/netshot /usr/local/netshot
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
"-start_mysql")
mysql_start
;;
*)
echo "Please specify one of the following switches when launching this script:"
echo "-install used to initalize the tables"
echo "-run used for inside supervisord "
exit 1
;;
esac
