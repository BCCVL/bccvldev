
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
    # wait until postgres is running, then kick off initialisation
    ./scripts init.sh

    # build bccvl dev container
    ./scripts/buildout.sh


4. Start all services
---------------------

.. code-block:: Shell

    docker-compose up -d

5. Create initial site
----------------------

.. code-block:: Shell

    # init bccvl site
    ./scripts/manage.sh


Access Site
===========

The script activate.sh prints the IP adress docker-machine is listening on. Use this email address to access the running services.

Direct access to Plone instance: http://192.168.99.100:8080
Access to BCCVL site: https://192.168.99.100

Install common test datasets
============================

.. code-block:: Shell

    # install test/dev datasets
    ./scripts/testsetup.sh --siteurl http://192.168.99.100:8080/bccvl/ --dev
    ./scripts/testsetup.sh --siteurl http://192.168.99.100:8080/bccvl/ --test


Run tests
=========

.. code-block:: Shell

    ./sripts/test.sh

Run Site upgrades
=================

.. code-block:: Shell

    # run all available upgrade steps
    ./srcipts/manage.sh --upgrade

    # re-run latest upgrade step
    ./sripts/manage.sh --lastupgrade


Run BCCVL instance in development mode
======================================

.. code-block:: Shell

    # stop bccvl container in case it is running
    docker-compose stop bccvl

    # start zope instance in foreground mode
    docker-compose run --rm --service-ports bccvl ./bin/instance fg
