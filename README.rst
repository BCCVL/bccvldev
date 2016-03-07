
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
    git clone git@github.com:BCCVL/BCCVL_Visualiser


3. Build dev env
----------------

.. code-block:: Shell

    . /scripts/activate.sh
    # don't forget to log in to our registry
    docker login hub.bccvl.org.au
    docker-compose build
    # init bccvl dev env ; necessary to setup git clones in host src folder
    docker-compose run --rm --no-deps bccvl ./build.sh


4. Run initial configuration
----------------------------

.. code-block:: Shell

    docker-compose up -d rabbitmq
    ./scripts/init.sh


5. Create initial site
----------------------

.. code-block:: Shell

    docker-compose run --rm bccvl ./bin/instance manage

6. Start everything else
------------------------

.. code-block::Shell

    docker-compose up


Access Site
===========

The script activate.sh prints the IP adress docker-machine is listening on. Use this email address to access the running services.

Direct access to Plone instance: http://192.168.99.100:8080
Access to BCCVL site: https://192.168.99.100

Install common test datasets
============================

.. code-block:: Shell

    ./scripts/testsetup.sh --dev
    ./scripts/testsetup.sh --test

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
