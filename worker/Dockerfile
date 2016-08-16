FROM hub.bccvl.org.au/bccvl/bccvlworker

RUN git clone git://github.com/BCCVL/org.bccvl.movelib.git && \
    git --git-dir org.bccvl.movelib/.git remote set-url --push origin git@github.com:BCCVL/org.bccvl.movelib.git && \
    pip2.7 install -e org.bccvl.movelib && \
    git clone git://github.com/BCCVL/org.bccvl.tasks.git && \
    git --git-dir org.bccvl.tasks/.git remote set-url --push origin git@github.com:BCCVL/org.bccvl.tasks.git && \
    pip2.7 install -e org.bccvl.tasks

# TODO: remove PTACH entrypoint untli base image is fixed
COPY entrypoint.sh /entrypoint.sh
