CREATE DATABASE netshot01 CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON netshot01.* TO 'netshot'@'localhost' IDENTIFIED BY 'netshot'; FLUSH PRIVILEGES;
CREATE TABLE netshot01.user (
			id bigint(20) NOT NULL AUTO_INCREMENT,
			hashed_password varchar(255) DEFAULT NULL,
			level int(11) NOT NULL,
			local bit(1) NOT NULL,
			username varchar(255) DEFAULT NULL,
			PRIMARY KEY (id),
			UNIQUE KEY UK_t8tbwelrnviudxdaggwr1kd9b (username)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO netshot01.user VALUES (1,'7htrot2BNjUV/g57h/HJ/C1N0Fqrj+QQ',1000, b'1','netshot');
