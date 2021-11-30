FROM httpd:2.4-alpine

EXPOSE 8903/tcp

RUN apk add curl iproute2 iputils less nano tree unzip ca-certificates tzdata rsync

ARG TIMEZONE
RUN ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

ARG APPOINTMENTS_URL=https://github.com/Bahmni/openmrs-module-appointments-frontend/releases/download/0.0.2/openmrs-module-appointments-frontend.zip

RUN mkdir -p /var/www/appointments/ \
 && curl -L --output /var/www/appointments/appointments.zip ${APPOINTMENTS_URL} \
 && unzip /var/www/appointments/appointments.zip -d /var/www/appointments/ \
 && rsync -av /var/www/appointments/dist/ /var/www/appointments/ \
 && rm /var/www/appointments/appointments.zip \
 && rm -r /var/www/appointments/dist

COPY resources/httpd.conf /usr/local/apache2/conf/httpd.conf

COPY resources/cgi-bin/systemdate.sh /usr/local/apache2/cgi-bin/systemdate
