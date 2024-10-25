FROM ubuntu:20.04
LABEL maintainer="maxmilio@kiv.zcu.cz" \
      org.opencontainers.image.source="https://github.com/maxotta/kiv-cloudlet-dev-container"

ARG WORKSPACE_DIR=/workspace
# Volume for preserving the private & public SSH keys for accessing remote VMs
ARG PERSISTENT_DATA_DIR=/var/cloudlet-dev-container-data
ARG CONFIG_DIR=/etc/cloudlet-config

ENV DEBIAN_FRONTEND noninteractive

# Prepare for the installation of external repositories
RUN set -uex; \
    apt-get update ; \
    apt-get -y install gnupg software-properties-common ca-certificates curl apt-transport-https ; \
    mkdir -p /etc/apt/keyrings

# Add HashiCorp repos and install Terraform
RUN set -uex; \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg ; \
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint ; \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list ; \
    apt-get update ;\
    apt-get -y install terraform

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

RUN echo '. /etc/init-dev-container.sh' >> /root/.bashrc ; \
    echo 'export TF_VAR_vm_ssh_pubkey="`cat ${PERSISTENT_DATA_DIR}/id_ecdsa.pub`"' >> /root/.bashrc

WORKDIR ${WORKSPACE_DIR}

VOLUME ${WORKSPACE_DIR} ${PERSISTENT_DATA_DIR}
VOLUME ${PROJECT_DIR}/config ${CONFIG_DIR}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV PERSISTENT_DATA_DIR ${PERSISTENT_DATA_DIR}
ENV CONFIG_DIR ${CONFIG_DIR}
ENV OPENVPN_CONFIG ${CONFIG_DIR}/OpenVPN-Config.ovpn
ENV ENV_CONFIG ${CONFIG_DIR}/.env
ENV SHELL /bin/bash
ENV ANSIBLE_HOST_KEY_CHECKING False

# Prevent the container to exit
CMD [ "sleep", "infinity" ]
