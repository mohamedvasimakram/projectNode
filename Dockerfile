FROM tomcat:9-jre9
MAINTAINER vasim1988n@gmail.com
COPY ./target/web2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8081
