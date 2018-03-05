FROM ubuntu:16.04
MAINTAINER Justin Guagliata "justin@guagliata.com"
RUN apt-get update

#set passwd for mysql root user
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -yq install openjdk-8-jre-headless  supervisor mysql-server-5.7 --no-install-recommends && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	mkdir -p /var/lib/mysql && \
	mkdir -p /var/run/mysqld && \
	mkdir -p /var/log/mysql && \
	mkdir -p  /var/log/supervisor && \
	chown -R mysql:mysql /var/lib/mysql && \
	chown -R mysql:mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/log/mysql 
COPY init.sh netshot.jar netshot.conf /usr/local/netshot/
COPY db.sql /tmp/db.sql
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN /usr/local/netshot/init.sh -install
EXPOSE 8443
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
