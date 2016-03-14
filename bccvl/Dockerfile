FROM hub.bccvl.org.au/bccvl/bccvl:1.11.0.dev

COPY buildout.cfg $Z_HOME/

ENV CONFIG buildout.cfg

RUN $Z_HOME/build.sh

RUN chmod -R o+r eggs/
