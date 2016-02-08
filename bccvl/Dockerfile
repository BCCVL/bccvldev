FROM hub.bccvl.org.au/bccvl/bccvl:1.10.1

COPY buildout.cfg $ZOPE_HOME/

ENV CONFIG buildout.cfg

RUN $ZOPE_HOME/build.sh
