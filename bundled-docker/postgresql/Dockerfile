FROM postgres:13

# Argument to enable/disable SSO
ARG ENABLE_SSO=false

ADD data/postgresql/create_db.sh /docker-entrypoint-initdb.d/create_db.sh
ADD data/postgresql/odoo /docker-entrypoint-initdb.d/db/odoo

# Copy SSO configurations & binaries to a temporary location
COPY data/postgresql/senaite /tmp/senaite
COPY data/postgresql/keycloak /tmp/keycloak

# Add SSO configurations & binaries if SSO is enabled
RUN if [ "$ENABLE_SSO" = "true" ]; then \
    cp -r /tmp/senaite /docker-entrypoint-initdb.d/db/senaite && \
    cp -r /tmp/keycloak /docker-entrypoint-initdb.d/db/keycloak; \
fi

# Remove the temporary SSO configurations & binaries \
RUN rm -rf /tmp/senaite && \
    rm -rf /tmp/keycloak \
