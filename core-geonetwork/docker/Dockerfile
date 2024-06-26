FROM maven:3.8.4-openjdk-11-slim AS build
# Set the working directory in the container
WORKDIR .
# Copy the pom.xml and the project files to the container
COPY core-geonetwork/pom.xml .
COPY core-geonetwork ./core-geonetwork
# Build the application using Maven
# RUN mvn clean package -DskipTests
RUN mvn -f core-geonetwork/pom.xml clean install -DskipTests -DschemasCopy=true -T 2C
# Use an official OpenJDK image as the base image
FROM openjdk:11-jre-slim
# Set the working directory in the container
WORKDIR /core-geonetwork
# # Copy the built JAR file from the previous stage to the container
# COPY - from=build /app/target/my-application.jar .
# # Set the command to run the application
CMD ["java", "-war", "geonetwork.war"]

FROM jetty:9-jdk8

ENV GN_FILE geonetwork.war
ENV GN_VERSION 4.2.8

ENV DATA_DIR /catalogue-data
ENV JAVA_OPTS -Dorg.eclipse.jetty.annotations.AnnotationParser.LEVEL=OFF \
        -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true \
        -Xms512M -Xss512M -Xmx2G -XX:+UseConcMarkSweepGC \
        -Dgeonetwork.resources.dir=${DATA_DIR}/resources \
        -Dgeonetwork.data.dir=${DATA_DIR} \
        -Dgeonetwork.codeList.dir=/var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/codelist \
        -Dgeonetwork.schema.dir=/var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins

USER root
RUN apt-get update && apt-get update && apt-get install -y unzip
RUN mkdir -p /catalogue-data && \
    chown -R jetty:jetty /catalogue-data && \
    mkdir -p /var/lib/jetty/webapps/geonetwork && \
    chown -R jetty:jetty /var/lib/jetty/webapps/geonetwork
COPY /docker-entrypoint.sh /geonetwork-entrypoint.sh    
RUN chmod 774 /geonetwork-entrypoint.sh

USER jetty
COPY core-geonetwork/web/target/geonetwork.war /var/lib/jetty/webapps/geonetwork/geonetwork.war

RUN  cd /var/lib/jetty/webapps/geonetwork/ && \
     unzip geonetwork.war && \
     rm geonetwork.war

#COPY ./docker-entrypoint.sh /geonetwork-entrypoint.sh
ENTRYPOINT ["/geonetwork-entrypoint.sh"]
CMD ["java","-jar","/usr/local/jetty/start.jar"]
