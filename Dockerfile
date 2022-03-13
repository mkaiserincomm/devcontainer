FROM       ubuntu:18.04
MAINTAINER Michael Kaiser
# git
# az
# kubectl
# kubeseal

RUN apt-get update
RUN apt-get install -y ca-certificates apt-transport-https lsb-release gnupg curl git
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg 
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" > /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update
RUN apt-get install -y azure-cli
RUN curl -LO "https://dl.k8s.io/release/v1.23.4/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl -LO "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.3/kubeseal-0.17.3-linux-amd64.tar.gz"
RUN tar -xzvf kubeseal-0.17.3-linux-amd64.tar.gz
RUN mv ./kubeseal /usr/local/bin
RUN rm kubeseal-0.17.3-linux-amd64.tar.gz
RUN rm LICENSE
RUN rm README.md

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
