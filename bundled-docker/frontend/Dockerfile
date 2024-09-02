FROM openmrs/openmrs-reference-application-3-frontend:nightly
ADD distro/binaries/openmrs/frontend /usr/share/nginx/html
ADD distro/configs/openmrs/frontend_config /usr/share/nginx/html/ozone
RUN mkdir -p /app
WORKDIR /app
COPY bundled-docker/frontend/startup.sh /app
RUN chmod +x /app/startup.sh
CMD ["/app/startup.sh"]