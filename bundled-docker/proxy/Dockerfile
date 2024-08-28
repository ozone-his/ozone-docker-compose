FROM nginx:1.25-alpine

ENV FRAME_ANCESTORS ""

COPY bundled-docker/proxy/nginx.conf /etc/nginx/nginx.conf
COPY bundled-docker/proxy/default.conf.template /etc/nginx/templates/