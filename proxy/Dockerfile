FROM nginx:1.28-alpine

RUN apk upgrade --no-cache brotli-libs

ENV FRAME_ANCESTORS ""

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf.template /etc/nginx/templates/
COPY bahmni/systemdate.sh /usr/local/bahmni/cgi-bin/systemdate
