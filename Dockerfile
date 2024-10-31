FROM ubuntu:20.04
LABEL maintainer="maxmilio@kiv.zcu.cz" \
      org.opencontainers.image.source="https://github.com/maxotta/kiv-cloudlet-dev-container"

# Set the default workspace directory   
ARG WORKSPACE_DIR=/workspace
# Path to the configuration directory
ARG CONFIG_DIR=/etc/cloudlet-config

ENV DEBIAN_FRONTEND noninteractive

# Prepare for the installation of external repositories
RUN set -uex; \
    apt-get update ; \
    apt-get -y install gnupg software-properties-common ca-certificates curl apt-transport-https ; \
    mkdir -p /etc/apt/keyrings

# Install Python toolset, Ansible and Docker libraries
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y install git python3.9 python3-pip pipenv
RUN pip install ansible ansible-lint
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

VOLUME [${WORKSPACE_DIR}, ${CONFIG_DIR}]

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV CONFIG_DIR ${CONFIG_DIR}
ENV OPENVPN_CONFIG ${CONFIG_DIR}/OpenVPN-Config.ovpn
ENV ENV_CONFIG ${CONFIG_DIR}/.env
ENV SHELL /bin/bash
ENV ANSIBLE_HOST_KEY_CHECKING False

# Prevent the container to exit
CMD [ "sleep", "infinity" ]
