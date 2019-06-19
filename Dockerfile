FROM centos:7
MAINTAINER "Roman Pavlyuk" <roman.pavlyuk@gmail.com>

ENV container docker

RUN yum install -y epel-release
#RUN yum install -y https://harbottle.gitlab.io/epmel/7/x86_64/epmel-release-7-3.el7.x86_64.rpm
RUN yum install -y https://harbottle.gitlab.io/epmel/7/x86_64/epmel-release-7-3.el7.harbottle.x86_64.rpm

RUN yum update -y

RUN yum install -y less file mc vim-enhanced telnet net-tools wget

### Let's enable systemd on the container
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Copy RPM packages to Docker image
COPY .rpms/ /rpms/

# Set what we've got
RUN ls -al /rpms

# Install ls-30 and PERL library
RUN yum localinstall -y /rpms/perl-* /rpms/ls-30*

RUN systemctl enable ls-30-proxy.service

# Installing CLAM
RUN yum install -y python2-pip autoconf gcc cpp python-devel
RUN pip install clam

VOLUME [ "/usr/share/LS30/clam" ]

# Enable SSHD on port 2222
RUN yum install -y openssh openssh-server
RUN systemctl enable sshd
RUN perl -pi -e "s|\#Port 22|Port 2222|gi" /etc/ssh/sshd_config
RUN perl -pi -e "s|\#PermitRootLogin yes|PermitRootLogin yes|gi" /etc/ssh/sshd_config

## Expose ports
EXPOSE 3000 1681 8888 2222

### Enable monit
RUN yum install -y monit
RUN systemctl enable monit
EXPOSE 2812


### Kick it off
CMD ["/usr/sbin/init"]
