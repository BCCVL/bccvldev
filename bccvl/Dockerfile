FROM hub.bccvl.org.au/bccvl/bccvl

RUN yum install -y git \
    && yum clean all

COPY files/development.cfg $BCCVL_HOME/

RUN ./bin/buildout -N -c development.cfg
