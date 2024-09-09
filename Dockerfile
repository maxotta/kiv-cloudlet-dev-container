FROM ubuntu:20.04
LABEL maintainer="maxmilio@kiv.zcu.cz" \
      org.opencontainers.image.source="https://github.com/maxotta/kiv-cloudlet-dev-container"

ARG WORKSPACE_DIR=/workspace
# Volume for preserving the private & public SSH keys for accessing remote VMs
ARG PERSISTENT_DATA_DIR=/var/kiv-cloudlet-dev-container-data
# Volume for mounting the OpenVPN configuration file into the container
ARG OPENVPN_CONFIG=/etc/OpenVPN-Config.ovpn

ENV DEBIAN_FRONTEND noninteractive

# Prepare for the installation of external repositories
RUN set -uex; \
    apt-get update ; \
    apt-get -y install gnupg software-properties-common ca-certificates curl apt-transport-https ; \
    mkdir -p /etc/apt/keyrings

# Install Python toolset, Ansible and Docker libraries
RUN apt-get -y install git python3 python3-pip pipenv
RUN pip install ansible
RUN pip install docker

RUN apt-get -y install sshpass
RUN apt-get -y install openvpn=2.4.12-0ubuntu0.20.04.2
RUN apt-get -y install inetutils-ping
RUN apt-get -y install apt-utils
RUN apt-get -y install cowsay
RUN apt-get -y install lolcat

COPY init-dev-container.sh /etc
COPY help.txt /etc

RUN echo '. /etc/init-dev-container.sh' >> /root/.bashrc

WORKDIR ${WORKSPACE_DIR}

VOLUME ${WORKSPACE_DIR} ${PERSISTENT_DATA_DIR}
VOLUME ${PROJECT_DIR}/vpn/OpenVPN-Config.ovpn ${OPENVPN_CONFIG}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PERSISTENT_DATA_DIR ${PERSISTENT_DATA_DIR}
ENV OPENVPN_CONFIG ${OPENVPN_CONFIG}
ENV SHELL /bin/bash
ENV ANSIBLE_HOST_KEY_CHECKING False

# Prevent the container to exit
CMD [ "sleep", "infinity" ]

