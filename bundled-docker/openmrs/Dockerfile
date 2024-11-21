FROM openmrs/openmrs-reference-application-3-backend:nightly
ADD binaries/openmrs/modules /openmrs/distribution/openmrs_modules
ADD configs/openmrs/initializer_config /openmrs/distribution/openmrs_config
ADD configs/openmrs/properties/fhirproxy.properties /openmrs/data/fhirproxy/config.properties
ADD configs/openmrs/properties/oauth2.properties /openmrs/data/oauth2.properties
