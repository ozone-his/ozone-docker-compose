FROM openmrs/openmrs-core:2.6.x-nightly-amazoncorretto-11

# Add modules & configurations for the ozone distribution
ADD distro/binaries/openmrs/modules /openmrs/distribution/openmrs_modules
ADD distro/configs/openmrs/initializer_config /openmrs/distribution/openmrs_config
ADD distro/configs/openmrs/properties/fhirproxy.properties /openmrs/data/fhirproxy/config.properties
ADD distro/configs/openmrs/properties/oauth2.properties /openmrs/data/oauth2.properties
ADD bundled-docker/openmrs/tomcat/server.xml /usr/local/tomcat/conf/server.xml
ADD bundled-docker/openmrs/log4j2.xml /openmrs/data/log4j2.xml
