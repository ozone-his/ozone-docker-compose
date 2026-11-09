FROM nginx:1.28-alpine

RUN apk upgrade --no-cache brotli-libs

ENV FRAME_ANCESTORS ""

COPY bundled-docker/proxy/nginx.conf /etc/nginx/nginx.conf
COPY bundled-docker/proxy/default.conf.template /etc/nginx/templates/
