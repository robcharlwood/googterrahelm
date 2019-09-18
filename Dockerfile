# base image and maintainer
FROM python:2.7.16-alpine3.10
LABEL maintainer="rob@bitniftee.com"

# define args
ARG GOOGLE_SDK_VERSION=263.0.0
ARG TERRAFORM_VERSION=0.12.9
ARG HELM_VERSION="v2.14.3"
ARG ANSIBLE_VERSION=2.7.12
ARG APP_USER=googterrahelm
ARG WORKING_DIRECTORY=/home/${APP_USER}

# setup a non-root user with home directory
RUN mkdir -p ${WORKING_DIRECTORY}/bin && \
    addgroup -g 1001 ${APP_USER} && \
    adduser -u 1001 -D ${APP_USER} -G ${APP_USER} && \
    chown -R ${APP_USER}:${APP_USER} ${WORKING_DIRECTORY}

# setup
WORKDIR ${WORKING_DIRECTORY}
RUN echo "****** Install system dependencies ******" && \
    apk update && apk upgrade && \
    apk add --no-cache tar wget openssl ca-certificates && \
    apk add --update --virtual ansible-build-deps libffi-dev openssl-dev build-base && \
    echo "****** Building Ansible: ${ANSIBLE_VERSION} ******" && \
    pip install ansible==${ANSIBLE_VERSION} && \
    echo "****** Remove unused system librabies ******" && \
    apk del ansible-build-deps && rm -rf /var/cache/apk/* && \
    mkdir -p /etc/ansible && \
    echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# env vars
ENV PATH ${WORKING_DIRECTORY}/bin:${WORKING_DIRECTORY}/google-cloud-sdk/bin:$PATH
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

# switch to non-root user
USER ${APP_USER}

# download and install google cloud, terraform and helm
RUN echo "****** Building Google Cloud: ${GOOGLE_SDK_VERSION}} ******" && \
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar -zxvf google-cloud-sdk-${GOOGLE_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${GOOGLE_SDK_VERSION}-linux-x86_64.tar.gz && \
    google-cloud-sdk/install.sh \
        --usage-reporting=false --path-update=true  \
        --bash-completion=true --rc-path=${WORKING_DIRECTORY}/.bashrc \
        --additional-components kubectl && \
    google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true && \
    echo "****** Building Terraform: ${TERRAFORM_VERSION} ******" && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d ${WORKING_DIRECTORY}/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "****** Building Helm: ${HELM_VERSION} ******" && \
    wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.zip && \
    unzip helm-${HELM_VERSION}-linux-amd64.zip && \
    mv ./linux-amd64/helm ${WORKING_DIRECTORY}/bin/helm && \
    rm -f helm-${HELM_VERSION}-linux-amd64.zip
