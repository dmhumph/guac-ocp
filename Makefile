PACKAGE	 = guacamole
VERSION	 = ` date "+%Y.%m%d%" `
RELEASE_DIR  = ..
RELEASE_FILE = $(PACKAGE)-$(VERSION)

deploy:

	docker run -d --name mariadb_database -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=some_password -e MYSQL_DATABASE=guacamole_db -e STARTUP_SQL="/mysql/schema/001-create-schema.sql /mysql/schema/002-create-admin-user.sql" -p 3306:3306 guacamole-mariadb
	docker run -d --name mariadb_database -e STARTUP_SQL="001-create-schema.sql 002-create-admin-user.sql" -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=some_password -e MYSQL_DATABASE=guacamole_db -p 3306:3306 -v `pwd`/container-scripts:/usr/share/container-scripts/mysql/ -it registry.access.redhat.com/rhscl/mariadb-101-rhel7
	docker run -p 4822:4822 -it guacamole-server
	docker run -it -e GUACD_HOSTNAME=localhost -e GUACD_PORT=4822 -e MYSQL_DATABASE=guacamole_db -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=some_password -e MYSQL_HOSTNAME=127.0.0.1 -e MYSQL_PORT=3306 -p 8080:8080 -p 9990:9990 guacamole-client -v /tmp/guac:/temp/ -e GUACAMOLE_HOME=/temp/ source/guacamole-docker/bin/start.sh

s2i:
	echo "building gcc s2i image"
	cd guacamole-server; \
	docker build -t gcc-builder .

	echo "building gcc s2i image"

build:

	echo "building guacamole-client"
	cd guacamole-client; \
	s2i build incubator-guacamole-client/ registry.access.redhat.com/jboss-eap-7/eap70-openshift guacamole-client -e ARTIFACT_DIR=guacamole/target,extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/target

	echo "building guacamole-server"
	cd guacamole-server; \
	s2i build guacamole-server-0.9.12-incubating/ gcc-builder guacamole-server

