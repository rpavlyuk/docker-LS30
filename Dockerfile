FROM centos:7
MAINTAINER "Roman Pavlyuk" <roman.pavlyuk@gmail.com>

ENV container docker

RUN yum install -y epel-release
RUN yum install -y https://harbottle.gitlab.io/epmel/7/x86_64/epmel-release-7-2.el7.x86_64.rpm

RUN yum update -y

RUN yum install -y less file mc vim-enhanced telnet net-tools 

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

# Install dependencies
RUN yum install -y perl \
	perl-TimeDate \
	perl-Data-Dumper \
	perl-AnyEvent \
	perl-YAML \
	perl-Mojolicious \
	perl-Digest-MD5 \
	perl-Digest-SHA \
	perl-Compress-Raw-Zlib

# Copy LS30 source
COPY LS30/ /usr/share/LS30/

# Copy exec script
COPY run-proxy-daemon.sh /usr/share/LS30/bin/

### Kick it off
CMD ["/usr/sbin/init"]
