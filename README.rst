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

    .. code-bolkc:: bash

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
        pushd src/bccvl_buildout
        git checkout feature/develop_docker
        popd

        # bootstrap dev env
        ./bin/devup.sh

6. trea down entire stack

    .. code-block:: bash

        openstack stack delete -y ${STACK_NAME}


Docker for Mac or Linux:
------------------------

1. clone dev repo

    .. code-block:: bash

        git clone https://github.com/BCCVL/bccvldev

2. optionally use cloud9 dev env

    Due to permission problems on Linux, it may be easier to start up the cloud9 dev env and use the terminal inside

    .. code-block:: bash

        ./bin/gen_config.sh
        docker-compose up -d nginxcloud9 cloud9

3. bootstrop dev env

    .. code-block:: bash

        ./bin/devup.sh

4. destroy dev env

    **Warning**: this may remove other containers and volumes from other projects as well. It clears everything not running or untagged managed by docker daemon.

    .. code-block:: bash

        sh ./bin/cleanup.sh

Vagrant: (suitable for Windows)
-------------------------------

The source code can be accessed via a samba share on 192.168.99.100

1. build VM

    .. code-block:: bash

        vagrant up

2. bring up Web IDE

    .. code-block:: bash

        vagrant ssh
        cd bccvldev
        /usr/local/bin/docker-compose up -d nginxcloud9 cloud9

3. log in the IDE

    .. code-block:: bash

        open https://192.168.99.100:8443

4. bring up dev env

    inside terminal in web ide

    .. code-block:: bash

        # log in to docker registry
        docker login hub.bccvl.org.au

        # get correct buildout branch
        ./bin/git_clone.sh
        pushd src/bccvl_buildout
        git checkout feature/develop_docker
        popd

        # bootstrap dev env
        ./bin/devup.sh

5. destroy dev env

    .. code-block:: bash

        vagrant destroy



TODOs
=====

    - document all helper scripts
    - document start/stop of services, how to run interactively for debugging, etc...
    - document how to run interactive debugger (esp. for celery backend jobs)
      -> probably best to add a telnet container and use that to connect to remote debugger
    - vagrant setup may need some more disk space (configurable?)
    - maybe add local swift server to setup ?
    - devup.sh sometimes fails due to relstorage or zodb conflict errors ... (add some delays? or make steps manual?)

