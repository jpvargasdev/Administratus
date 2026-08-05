#!/bin/sh
set -eu

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -tc \
	"SELECT 1 FROM pg_database WHERE datname = 'license_admin'" | grep -q 1 || \
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c \
	"CREATE DATABASE license_admin OWNER $POSTGRES_USER"
