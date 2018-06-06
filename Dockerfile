#### SVK-UB16-DockerFile-06-Jun-2018 ####
FROM ubuntu:16.04
MAINTAINER SVK
RUN apt update && \
apt install -y sudo vim wget net-tools openssh-server supervisor iputils-ping iproute2 nmap tzdata
RUN useradd -s /bin/bash -m svkdokr && (echo "12345";echo "12345")|passwd svkdokr \
&& usermod -aG sudo svkdokr \
&& mkdir /svk-$(date +%d%b%Y) \
### Set IST TimeZOne ###
&& ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime \
&& dpkg-reconfigure -f noninteractive tzdata
### Open ports ###
EXPOSE 22
RUN mkdir /var/run/supervisor && mkdir /var/run/sshd
### supervisord config ###
RUN echo [supervisord] > /etc/supervisor/conf.d/ssh.conf \
&& echo 'nodaemon=true' >> /etc/supervisor/conf.d/ssh.conf \
### Add sshd program to supervisord config ###
&& echo [program:sshd] >> /etc/supervisor/conf.d/ssh.conf \
&& echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/conf.d/ssh.conf\
&& echo  >> /etc/supervisor/conf.d/supervisord.conf 
### Commnad to Execute on startup ###
ENTRYPOINT ["/usr/bin/supervisord"]
##################################### 
