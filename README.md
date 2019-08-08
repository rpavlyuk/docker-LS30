# docker-LS30: LifeSOS LS-30 Control unit management as Docker container
Docker Container that runs utilities to control LifeSOS LS-30 home security appliance. This container is based on the Perl-driven toolkit writen by *nikandrew* (https://github.com/nickandrew/LS30).

The container provides command-line as well as some API-like programmable interface so you can integrate LifeSOS LS-30 into your smart home ecosystem.

## Features
* Based on CentOS 7.x image
* LS-30 Perl module packaged in RPM and installed with all dependencies
* Monit (https://mmonit.com/monit/) is installed and sample configuration is provided to integrate the system with Domoticz (https://www.domoticz.com)
* Zabbix Agent is installed and configured to monitor LS-30 state


## Running the Container
It is recommended to run the container using ```systemdock``` as there are several pre- and post-configuration steps to be done and ```systemdock``` will take care of them. Also, main feature of ```systemdock``` is that it runs the container as SystemD service, thus allowing the container to be correctly started in system boot. 
* First, install ```systemdock```. See instruction here: https://github.com/rpavlyuk/systemdock
* Download the actual source:
```
git clone https://github.com/rpavlyuk/docker-LS30.git docker-LS30 && cd ./docker-LS30
```
* Install ```LS-30``` module for ```systemdock```:
```
cd systemdock-LS30/
sudo make install
```
NOTE: If you've installed ```systemdock``` using RPM, then you might want to install the module the same way. In that run:
```
sudo make install-rpm
```
* Let's verify if the module has been installed correctly by checking if it was picked up by ```systemdock```:
```
$ systemdock -a list
INFO: SystemDock version 0.2
INFO: More info here: https://github.com/rpavlyuk/systemdock
INFO: List of all services managed by SystemDock
LS-30 | systemdock-LS30.service | INNACTIVE | DISABLED
```
* Now, let's enable the service in a usual for SystemD way:
```
systemctl enable systemdock-LS30.service
```
* Edit container startup configuration file ```/etc/systemdock/containers.d/LS-30/config.yml``` and find&replace sample connection info ```192.168.1.220:1681``` with ```ip:port``` for your LifeSOS TCP module.
* Now, let's start the service:
```
systemctl start systemdock-LS30.service
```
* This should start ```LS-30``` docker container. You can its running by issuing ```docker ps```.
* If you experience any issues with container startup, check the log file by calling:
```
journalctl -u systemdock-LS30
```

Still, you may run the container using ```docker run``` command. Just translate instructions from ```[SOURCE_ROOT]/systemdock-LS30/LS-30/config.yml``` to proper command-line options.

## Playing with Container
* Enter container's shell:
```
docker exec -ti LS-30 bash
```
* Check the status of LS-30:
```
[root@LS-30 ~]# /usr/share/LS30/bin/get-mode.pl
Disarm
```
You may find the description of some of the command-line tools at https://github.com/nickandrew/LS30. All of the are available in ```/usr/share/LS30/bin``` directory.

# TO-DO
* Add documentation for Zabbix and Domoticz integration

