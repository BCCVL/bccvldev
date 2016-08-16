
===============
Docker Machine:
===============


Getting Started
===============


1. Create and start docker machine
----------------------------------

.. code-block:: Shell

    docker-machine create --driver virtualbox --virtualbox-cpu-count 4 --virtualbox-memory 4096 bccvldev
    docker-machine start bccvldev


2. Clone dev env
----------------

.. code-block:: Shell

    git clone git@github.com:BCCVL/bccvldev
    cd bccvldev
    git clone -b docker git@github.com:BCCVL/BCCVL_Visualiser


3. Build dev env
----------------

.. code-block:: Shell

    source scripts/activate.sh
    # don't forget to log in to our registry
    docker login hub.bccvl.org.au
    docker-compose build
    # start and init storage container
    docker-compose up -d postgis
    docker-compose exec --user postgres postgis createuser plone
    docker-compose exec --user postgres postgis createdb -O plone plone
    docker-compose exec --user postgres postgis psql -c "alter user plone with password 'plone';"
    # init visualiser db
    docker-compose exec --user postgres postgis createuser visualiser
    docker-compose exec --user postgres postgis createdb -O visualiser visualiser
    docker-compose exec --user postgres postgis psql -c "alter user visualiser with password 'visualiser';"
    docker-compose exec --user postgres postgis psql -d visualiser -c "CREATE EXTENSION postgis;"
    # build bccvl dev container
    docker-compose run --rm bccvl ./bin/buildout -N -c development.cfg


4. Start all services
---------------------

.. code-block:: Shell

    docker-compose up -d

5. Create initial site
----------------------

.. code-block:: Shell

    # init bccvl site
    docker-compose run --rm bccvl ./bin/instance manage


Access Site
===========

The script activate.sh prints the IP adress docker-machine is listening on. Use this email address to access the running services.

Direct access to Plone instance: http://192.168.99.100:8080
Access to BCCVL site: https://192.168.99.100

Install common test datasets
============================

.. code-block:: Shell

    # install test/dev datasets
    docker-compose run --rm bccvl ./bin/instance testsetup --siteurl http://192.168.99.100:8080/bccvl/ --dev
    docker-compose run --rm bccvl ./bin/instance testsetup --siteurl http://192.168.99.100:8080/bccvl/ --test

Run tests
=========

.. code-block:: Shell

    docker-compose run --rm bccvl -u zope ./bin/test

Run Site upgrades
=================

.. code-block:: Shell

    # run all available upgrade steps
    docker-compose run --rm bccvl ./bin/instance manage --upgrade

    # re-run latest upgrade step
    docker-compose run --rm bccvl ./bin/instance manage --lastupgrade

Run BCCVL instance in development mode
======================================

.. code-block:: Shell

    # stop bccvl container in case it is running
    docker-compose stop bccvl

    # start zope instance in foreground mode
    docker-compose run --rm --service-ports bccvl ./bin/instance fg
