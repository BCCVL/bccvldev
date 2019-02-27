=============
BCCVL Dev Env
=============


Use Heat:
---------

1. setup names

    .. code-block:: bash

       STACK_NAME=<mystack>
       SERVER_NAME=<myserver>
       BCCVLHUB_USER=<user>
       BCCVLHUB_PASS=<pass>

2. create stack

    .. code-block:: bash

        openstack stack create \
            --parameter name=${SERVER_NAME} \
            --parameter bccvlhub_user=${BCCVLHUB_USER} \
            --parameter bccvlhub_pass=${BCCVLHUB_PASS} \
            -t https://raw.githubusercontent.com/BCCVL/bccvldev/master/heat.yml \
            ${STACK_NAME}

3. wait for stack to set up everything

    .. code-block:: bash

        # show status of stack
        openstack stack show ${STACK_NAME}

        # show output of stack (reveals admin password to log into services)
        openstack stack output show --all ${STACK_NAME}

        # show logs for created instance
        openstack console log show --lines 200 ${SERVER_NAME}

4. open browser

    .. code-block:: bash

        # OS-X
        open "https://${SERVER_NAME}.nectar.bccvl.org.au:8443"

        # Linux
        xdg-open "https://${SERVER_NAME}.nectar.bccvl.org.au:8443"

        # Windows
        start "https://${SERVER_NAME}.nectar.bccvl.org.au:8443"

5. bootstrap dev env

    inside a terminal in the cloud9 dev env

    .. code-block:: bash

        # log in to docker registry
        docker login hub.bccvl.org.au

        # get correct buildout branch
        ./bin/git_clone.sh

        # bootstrap dev env
        ./bin/devup.sh

6. tear down entire stack

    .. code-block:: bash

        openstack stack delete -y ${STACK_NAME}


Docker for Mac or Linux:
------------------------

Use with whatever IDE you prefer.

1. clone dev repo

    .. code-block:: bash

        git clone https://github.com/BCCVL/bccvldev

2. bootstrap dev env

    .. code-block:: bash

        ./bin/devup.sh
    
    If the database of the project is not populated after this process is complete, you may wish to run the following:

    .. code-block:: bash

        ./bin/manage.sh

3. destroy dev env

    **Warning**: this may remove other containers and volumes from other projects as well. It clears everything not running or untagged managed by docker daemon.

    .. code-block:: bash

        sh ./bin/cleanup.sh

Vagrant: (suitable for Windows)
-------------------------------

The source code can be accessed via a samba share on 192.168.99.100

1. build VM

    You can set env variables to configure some aspects of the built VM.
    This is entirely optional. If hub credentials are not set, you can login
    later when VM is running. If admin password is not set, then provisioner
    will create one.

    .. code-block:: bash
        # pre define admin password
        export C9_PASS=
        # set bccvl hub user and password so that provisioner will log vm in
        export BCCVL_HUB_USER=
        export BCCVL_HUB_PASS=

    # bring up VM

    .. code-block:: bash

        # install useful vagrant plugins
        vagrant plugin install vagrant-vbguest vagrant-reload
        vagrant up

        # Note password echoed to console

2. log in the IDE

    .. code-block:: bash

        open https://192.168.99.100:8443

3. bring up dev env

    inside terminal in web ide

    .. code-block:: bash

        # log in to docker registry
        docker login hub.bccvl.org.au

        # get correct buildout branch
        ./bin/git_clone.sh

        # bootstrap dev env
        ./bin/devup.sh

4. destroy dev env

    .. code-block:: bash

        vagrant destroy

Notes:
======

- If you encounter issues with resolving and installing packages during installation, you may need to change ``allow-hosts`` in ``bccvl.cfg`` to add hosts where packages are being served.

Usage:
======

- changes to bccvl_buildout:

    Run ``docker-compose build bccvl`` . This will rebuild the development container applying the changed buildout configuration.

    In case of changes to checkouts.cfg you probably want to run ``./bin/buildout.sh`` as well.

- run plone instance in foreground mode:

    ``docker-compose run --rm --service-ports --name bccvl bccvl ./bin/instance fg``.
    Alternatively start the container with a shell and run the instance.
    ``docker-compose run --rm --service-ports --name bccvl bccvl bash``
    ``./bin/instance fg``. Any changes made to files in the container will be gone as soon as the container exits.

    If a container with name ``bccvl`` already exists run ``docker-compose rm bccvl`` first.

- recreate containers / services

    .. code-block:: bash

        docker-compose stop <service>
        docker-compose rm <service>
        docker-compose up -d <service>

TODOs
=====

    - set DIAZO_ALWAYS_CACHE_RULES=true to avoid recompiling rules on every request (in debug/foreground mode)
    - document: all helper scripts
    - document: start/stop of services, how to run interactively for debugging, etc...
    - document: how to run interactive debugger (esp. for celery backend jobs)
      -> probably best to add a telnet container and use that to connect to remote debugger
    - vagrant: setup may need some more disk space (configurable?)
    - devenv: maybe add local swift server to setup ?
    - devup.sh: sometimes fails due to relstorage or zodb conflict errors ... (add some delays? or make steps manual?)
