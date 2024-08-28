FROM mariadb:10.8
ADD data/mysql/create_db.sh /docker-entrypoint-initdb.d/create_db.sh
ADD data/mysql/eip-odoo-openmrs /docker-entrypoint-initdb.d/db/eip-odoo-openmrs
ADD data/mysql/openmrs /docker-entrypoint-initdb.d/db/openmrs
ADD data/mysql/eip-openmrs-senaite /docker-entrypoint-initdb.d/db/eip-openmrs-senaite