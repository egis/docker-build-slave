FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update && \
    apt-get install python-software-properties software-properties-common apt-transport-https \
                    build-essential curl wget git sudo -q -y && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer -q -y && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Add playbooks to the Docker image
ADD ansible /opt/ansible
WORKDIR /opt/ansible

# Execute Ansible with your playbook's primary entry point.
# The "-c local" argument causes Ansible to use a "local connection" that won't attempt to
# ssh in to localhost.
RUN ansible-playbook site.yml -c local 

ADD start.sh /opt/
WORKDIR /opt
CMD ["/opt/start.sh"]

