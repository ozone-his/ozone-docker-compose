FROM openmrs/openmrs-reference-application-3-backend:nightly

# Remove modules & configurations from OpenMRS Reference Application
RUN find /openmrs/distribution/openmrs_modules -mindepth 1 -delete || true
RUN find /openmrs/distribution/openmrs_config -mindepth 1 -delete || true

# Add modules & configurations for the ozone distribution
ADD distro/binaries/openmrs/modules /openmrs/distribution/openmrs_modules
ADD distro/configs/openmrs/initializer_config /openmrs/distribution/openmrs_config
ADD distro/configs/openmrs/properties/fhirproxy.properties /openmrs/data/fhirproxy/config.properties
ADD distro/configs/openmrs/properties/oauth2.properties /openmrs/data/oauth2.properties
ADD bundled-docker/openmrs/tomcat/server.xml /usr/local/tomcat/conf/server.xml
