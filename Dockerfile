FROM ubuntu

RUN apt-get update

RUN apt-get install -y openssh-server nginx
RUN systemctl enable nginx
RUN mkdir /var/run/sshd

RUN echo "root:Docker!" | chpasswd 

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN rm -f /var/www/html/index.nginx-debian.html
COPY index.html /var/www/html/index.html
RUN chmod +x /entrypoint.sh
COPY sshd_config /etc/ssh/
EXPOSE 80 2222

CMD    ["/entrypoint.sh"]