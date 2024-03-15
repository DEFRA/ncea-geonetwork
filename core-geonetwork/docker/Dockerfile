FROM jetty:9-jdk8

ENV DATA_DIR /catalogue-data
ENV JAVA_OPTS -Dorg.eclipse.jetty.annotations.AnnotationParser.LEVEL=OFF \
        -Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true \
        -Xms512M -Xss512M -Xmx2G -XX:+UseConcMarkSweepGC \
        -Dgeonetwork.resources.dir=${DATA_DIR}/resources \
        -Dgeonetwork.data.dir=${DATA_DIR} \
        -Dgeonetwork.codeList.dir=/var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/codelist \
        -Dgeonetwork.schema.dir=/var/lib/jetty/webapps/geonetwork/WEB-INF/data/config/schema_plugins 

USER root
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \ 
        curl \
        wget \
        unzip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p ${DATA_DIR} && \
    chown -R jetty:jetty ${DATA_DIR} && \
    mkdir -p /var/lib/jetty/webapps/geonetwork && \
    chown -R jetty:jetty /var/lib/jetty/webapps/geonetwork
RUN rm /docker-entrypoint.sh
USER jetty
COPY geonetwork.war /var/lib/jetty/webapps/geonetwork/geonetwork.war

RUN  cd /var/lib/jetty/webapps/geonetwork/ && \
     unzip geonetwork.war && \
     rm geonetwork.war 


RUN curl -O https://github.com/geonetwork/docker-geonetwork/blob/983310e129d2a55e6481042cc8d90a1b33ddf128/4.2.7/docker-entrypoint.sh 

COPY ./docker-entrypoint.sh /geonetwork-entrypoint.sh
ENTRYPOINT ["/geonetwork-entrypoint.sh"]
CMD ["java","-jar","/usr/local/jetty/start.jar"]

VOLUME [ "${DATA_DIR}" ]
