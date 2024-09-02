FROM postgres:13
ADD data/postgresql/create_db.sh /docker-entrypoint-initdb.d/create_db.sh
ADD data/postgresql/odoo /docker-entrypoint-initdb.d/db/odoo