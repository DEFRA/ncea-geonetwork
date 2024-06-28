FROM maven:latest AS build
# Set the working directory in the container
WORKDIR /
# Copy the pom.xml and the project files to the container
COPY core-geonetwork/pom.xml .
COPY core-geonetwork/. .
# Build the application using Maven
RUN mvn -f pom.xml clean install -DskipTests -DschemasCopy=true -T 1 -X -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.wagon.http.ssl.check.disable=true -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.resolver.transport=wagon

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

COPY core-geonetwork/docker/docker-entrypoint.sh /geonetwork-entrypoint.sh
RUN chmod 774 /geonetwork-entrypoint.sh

USER jetty
COPY --from=build ./web/target/geonetwork.war /var/lib/jetty/webapps/geonetwork/geonetwork.war

RUN  cd /var/lib/jetty/webapps/geonetwork/ && \
     unzip geonetwork.war && \
     rm geonetwork.war

ENTRYPOINT ["/geonetwork-entrypoint.sh"]
CMD ["java","-jar","/usr/local/jetty/start.jar"]
