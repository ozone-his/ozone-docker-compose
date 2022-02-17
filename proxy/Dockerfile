FROM httpd:2.4-alpine

RUN apk add curl iproute2 iputils less nano tree ca-certificates lsof --no-cache

COPY resources/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY resources/proxy-rules /usr/local/apache2/conf/proxy-rules
COPY resources/tls/cert.pem resources/tls/privkey.pem resources/tls/chain.pem /etc/tls/
EXPOSE 8069/tcp
