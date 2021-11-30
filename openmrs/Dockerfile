FROM tomcat:7-jre8-alpine
ARG OPENMRS_WAR_URL=https://openmrs.jfrog.io/artifactory/public/org/openmrs/web/openmrs-webapp/2.3.3/openmrs-webapp-2.3.3.war

RUN apk add mysql-client gettext coreutils curl wget

COPY setenv.sh /usr/local/tomcat/bin/setenv.sh
COPY setenv.sh /usr/local/tomcat/bin/setenv.sh

COPY wait-for-it.sh /usr/local/tomcat/wait-for-it.sh
COPY startup.sh /usr/local/tomcat/startup.sh
COPY tomcat/web.xml /usr/local/tomcat/conf/web.xml

RUN sed -i '/Connector port="8080"/a URIEncoding="UTF-8" relaxedPathChars="[]|" relaxedQueryChars="[]|{}^&#x5c;&#x60;&quot;&lt;&gt;"' /usr/local/tomcat/conf/server.xml

RUN chmod +x /usr/local/tomcat/wait-for-it.sh
RUN chmod +x /usr/local/tomcat/startup.sh
RUN wget -O /usr/local/tomcat/webapps/openmrs.war ${OPENMRS_WAR_URL} \
        && wget -O /usr/local/tomcat/lib/simpleclient_common-0.10.0.jar https://repo1.maven.org/maven2/io/prometheus/simpleclient_common/0.10.0/simpleclient_common-0.10.0.jar \
        && wget -O /usr/local/tomcat/lib/simpleclient_hotspot-0.10.0.jar https://repo1.maven.org/maven2/io/prometheus/simpleclient_hotspot/0.10.0/simpleclient_hotspot-0.10.0.jar \
        && wget -O /usr/local/tomcat/lib/simpleclient_servlet-0.10.0.jar https://repo1.maven.org/maven2/io/prometheus/simpleclient_servlet/0.10.0/simpleclient_servlet-0.10.0.jar \
        && wget -O /usr/local/tomcat/lib/simpleclient-0.10.0.jar https://repo1.maven.org/maven2/io/prometheus/simpleclient/0.10.0/simpleclient-0.10.0.jar \
        && wget -O /usr/local/tomcat/lib/tomcat_exporter_client-0.0.14.jar https://repo1.maven.org/maven2/nl/nlighten/tomcat_exporter_client/0.0.14/tomcat_exporter_client-0.0.14.jar \
        && wget -O /usr/local/tomcat/webapps/metrics.war https://repo1.maven.org/maven2/nl/nlighten/tomcat_exporter_servlet/0.0.14/tomcat_exporter_servlet-0.0.14.war


CMD ["/usr/local/tomcat/startup.sh"]
