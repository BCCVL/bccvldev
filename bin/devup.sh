#!/bin/bash

source "./bin/settings.sh"

# helper method to wait until postgres is ready to accept connections
function wait_for_postgres() {
    docker-compose up -d postgres
    # Wait for the postgres port to be available
    until docker-compose run --rm -u postgres postgres /usr/pgsql-9.5/bin/pg_isready -h postgres; do
        echo "waiting for postgres container..."
        sleep 1
    done
}

# TODO: postgres container starts and stops a couple of times before being ready....
#       need to update my postgres start script to handle that properly
function init_postgres() {
    # Start database and set up inital users
    wait_for_postgres
    sleep 5

    docker-compose exec --user postgres postgres createuser plone
    docker-compose exec --user postgres postgres createdb -O plone plone
    docker-compose exec --user postgres postgres psql -c "alter user plone with password 'plone';"

    docker-compose exec --user postgres postgres createuser visualiser
    docker-compose exec --user postgres postgres createdb -O visualiser visualiser
    docker-compose exec --user postgres postgres psql -c "alter user visualiser with password 'visualiser';"
    docker-compose exec --user postgres postgres psql -d visualiser -c "CREATE EXTENSION postgis;"
}

# 1. clone sources
./bin/git_clone.sh
# 2. generate config
./bin/gen_config.sh
# 3. init database
init_postgres
# 4. build containers
docker-compose build --pull
# 5. run buildout
./bin/buildout.sh
# 6. install initial site
./bin/manage.sh
# 7. start up everything
docker-compose up -d
# 8. cerate initial site
./bin/manage.sh  --id bccvl --title BCCVL
# 9. install dev/test data
./bin/testsetup.sh --dev
./bin/testsetup.sh --test
# 10. echo info
echo "Site available at https://$BCCVL_HOSTNAME"
