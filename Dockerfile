FROM tomcat:9-jre9

MAINTAINER vasim1988n@gmail.com

RUN rm -rf /usr/local/tomcat/webapps/ROOT/*
COPY index.html /usr/local/tomcat/webapps/ROOT/index.html

EXPOSE 8081
