#!/bin/bash

# set up environment variables
# export CATALINA_HOME=/usr/local/tomcat
# export CATALINA_BASE=/usr/local/tomcat
# export CATALINA_OPTS="-Xmx512M -Djava.security.egd=file:/dev/./urandom"

# start Tomcat
exec ${CATALINA_HOME}/bin/catalina.sh run
