FROM hub.bccvl.org.au/centos/centos7-epel:2016-02-04

RUN yum install -y openssh-server openssh-clients && \
    yum clean all

ENV Z_HOME=/opt/zope
ENV Z_CONF=/etc/opt/zope

RUN groupadd -g 414 zope && \
    useradd -u 414 -g 414 -d $Z_HOME -m -s /bin/bash zope && \
    mkdir -p $Z_CONF

COPY cmd.sh /cmd.sh

RUN chmod +x /cmd.sh

CMD /cmd.sh
