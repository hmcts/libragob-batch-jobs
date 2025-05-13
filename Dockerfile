FROM ubuntu:24.04
ARG SCRIPT_FILE
ENV SCRIPT=${SCRIPT_FILE}

ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certi***REMOVED***cates \
  curl \
  gnupg

ENV KUBECTL_VERSION=v1.33

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBECTL_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
  postgresql-client \
  bc \
  openssh-client \
  kubectl

COPY scripts/${SCRIPT_FILE} ${SCRIPT_FILE}
COPY sql sql
RUN chmod +x ${SCRIPT_FILE}

ENTRYPOINT bash "$SCRIPT"
