FROM hub.bccvl.org.au/bccvl/bccvl:1.10.1

COPY buildout.cfg $Z_HOME/

ENV CONFIG buildout.cfg

RUN $Z_HOME/build.sh

RUN chmod -R o+r eggs/
