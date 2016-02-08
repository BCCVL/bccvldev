FROM hub.bccvl.org.au/centos/centos7-epel:2016-02-04

RUN yum install -y openssh-server openssh-clients && \
    yum clean all

ENV ZOPE_HOME=/opt/zope

RUN groupadd -g 414 zope && \
    useradd -u 414 -g 414 -d $ZOPE_HOME -m -s /bin/bash zope

COPY cmd.sh /cmd.sh

RUN chmod +x /cmd.sh

CMD /cmd.sh
