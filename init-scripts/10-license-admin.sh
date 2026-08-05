#!/bin/sh
set -eu

: "${LICENSE_ADMIN_DB_PASSWORD:?LICENSE_ADMIN_DB_PASSWORD is required}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-SQL
	DO \$\$
	BEGIN
	   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'license_admin') THEN
	      CREATE ROLE license_admin LOGIN PASSWORD '$LICENSE_ADMIN_DB_PASSWORD';
	   END IF;
	END
	\$\$;
SQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -tc \
	"SELECT 1 FROM pg_database WHERE datname = 'license_admin'" | grep -q 1 || \
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c \
	"CREATE DATABASE license_admin OWNER license_admin"
