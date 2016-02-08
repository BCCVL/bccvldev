
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

    git clone git@github.com/BCCVL/bccvldev
    cd bccvldev
    git clone git@github.com/BCCVL/BCCVL_Visualiser


3. Bring up env
---------------

.. code-block:: Shell

    . /scripts/activate.sh
    docker-compose up


4. Run initial configuration
----------------------------

.. code-block:: Shell

    ./scripts/init.sh


Access Site
===========

The script activate.sh prints the IP adress docker-machine is listening on. Use this email address to access the running services.

Direct access to Plone instance: http://192.168.99.100:8080
Access to BCCVL site: https://192.168.99.100

Install common test datasets
============================

.. code-block:; Shell

    ./scripts/testsetup.sh --dev
    ./scripts/testsetup.sh --test

