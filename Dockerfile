FROM alpine:3.18.5
#FROM alpine:3.17.2
LABEL maintainer="DevOps 6D"
USER root
ENV TOMCAT_VERSION=10.1.16
ENV CATALINA_HOME /opt/tomcat

RUN apk add --update \
    curl \
    bash 

RUN apk add --no-cache openjdk11-jre-headless
RUN rm /var/cache/apk/* \
 && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security
RUN apk upgrade --available && sync
RUN addgroup --gid 1000 tomcat
RUN adduser -u 1000 -D -s /bin/bash -G tomcat tomcat

RUN cd /opt && \
    wget https://downloads.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    tar -zxvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm -rf apache-tomcat-${TOMCAT_VERSION}/webapps/examples && \
    rm -rf apache-tomcat-${TOMCAT_VERSION}/webapps/docs && \
    rm -rf apache-tomcat-${TOMCAT_VERSION}/webapps/manager && \
    rm -rf apache-tomcat-${TOMCAT_VERSION}/webapps/host-manager && \
    chown -R 1000:1000 /opt/apache-tomcat-${TOMCAT_VERSION} && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
    chown -R 1000:1000 /opt/tomcat


COPY ./start-tomcat.sh /usr/local/bin/start-tomcat.sh
RUN chmod +x /usr/local/bin/start-tomcat.sh
ENV CATALINA_BASE /opt/tomcat
ENV CATALINA_OPTS "-Xmx512M -Djava.security.egd=file:/dev/./urandom"
ENV PATH $CATALINA_HOME/bin:$PATH
RUN apk del busybox
RUN apk del --purge busybox

USER tomcat

# Expose port 8080
EXPOSE 8080
WORKDIR /opt/tomcat

ENTRYPOINT ["/usr/local/bin/start-tomcat.sh"]

