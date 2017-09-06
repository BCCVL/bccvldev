FROM hub.bccvl.org.au/centos/centos7-epel:2017-02-20

RUN rm -fr /var/lib/yum/yumdb/* && \
    yum install -y openssh-server openssh-clients && \
    yum clean all

ENV BCCVL_USER bccvl
ENV BCCVL_HOME /opt/${BCCVL_USER}
ENV BCCVL_VAR /var/opt/${BCCVL_USER}
ENV BCCVL_ETC /etc/opt/${BCCVL_USER}

RUN groupadd -g 414 ${BCCVL_USER} && \
    useradd -u 414 -g 414 -d ${BCCVL_HOME} -m -s /bin/bash ${BCCVL_USER} && \
    mkdir -p ${BCCVL_ETC}/ssh

COPY cmd.sh /cmd.sh

CMD /cmd.sh
