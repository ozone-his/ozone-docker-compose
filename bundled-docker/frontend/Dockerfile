FROM openmrs/openmrs-reference-application-3-frontend:nightly

ARG ENABLE_SSO=false

ADD distro/binaries/openmrs/frontend /usr/share/nginx/html
ADD distro/configs/openmrs/frontend_config /usr/share/nginx/html/configs

# Copy SSO configuration file to a temporary location
COPY distro/configs/openmrs/frontend_config_sso/ozone-frontend-config-sso.json /tmp/ozone-frontend-config-sso.json

# Add SSO configurations if SSO is enabled
RUN if [ "$ENABLE_SSO" = "true" ]; then \
    cp /tmp/ozone-frontend-config-sso.json /usr/share/nginx/html/configs/ozone-frontend-config-sso.json; \
fi

# Remove the temporary SSO configuration file
RUN rm /tmp/ozone-frontend-config-sso.json

RUN mkdir -p /app
WORKDIR /app
COPY bundled-docker/frontend/startup.sh /app
RUN chmod +x /app/startup.sh
CMD ["/app/startup.sh"]
