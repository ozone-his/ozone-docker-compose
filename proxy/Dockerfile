FROM nginx:1.25-alpine

ENV FRAME_ANCESTORS ""

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf.template /etc/nginx/templates/
COPY bahmni/systemdate.sh /usr/local/bahmni/cgi-bin/systemdate