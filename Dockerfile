FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci \
  && echo 'APT::Get::force-Yes "true";' >> /etc/apt/apt.conf.d/90circleci \
  && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci

RUN apt-get update && \
  apt-get install software-properties-common apt-transport-https \
                  build-essential curl wget git sudo -q -y && \
  apt-add-repository ppa:ansible/ansible && \
  apt-get update && \
  apt-get install -y ansible && \
  apt-get install openjdk-8-jdk && \
  apt-get install jq

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts

ADD ansible /opt/ansible
WORKDIR /opt/ansible

RUN ansible-playbook site.yml -c local -t system-packages
RUN ansible-playbook site.yml -c local -t java

RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

CMD ["/bin/zsh"]

