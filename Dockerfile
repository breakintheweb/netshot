FROM ubuntu:16.04
MAINTAINER Justin Guagliata "justin@guagliata.com"
RUN apt-get update
#java 8 is currently broken in ubuntu, lets use openjdk
RUN apt-get install -yq openjdk-8-jre-headless  supervisor
RUN mkdir -p  /var/log/supervisor
#MySQL specific
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -y install mysql-server-5.7 && \
	mkdir -p /var/lib/mysql && \
	mkdir -p /var/run/mysqld && \
	mkdir -p /var/log/mysql && \
	chown -R mysql:mysql /var/lib/mysql && \
	chown -R mysql:mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/log/mysql 
RUN chown -R mysql:mysql  /var/log/supervisor
COPY mysql.sh /tmp/mysql.sh
COPY netshot.jar /usr/local/netshot/netshot.jar
COPY netshot.conf /usr/local/netshot/netshot.conf
RUN /tmp/mysql.sh -install
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8443
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
