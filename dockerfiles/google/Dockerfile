# ------------------------------------------------------------------------------
# First stage: compiling Exekube CLI
# ------------------------------------------------------------------------------
FROM golang:1.12-alpine AS builder

RUN apk add --no-cache \
        git

ENV GOPATH /build
WORKDIR /build

RUN go get \
        github.com/urfave/cli \
        github.com/sirupsen/logrus

ADD ./cli ./src/github.com/exekube/exekube/cli

RUN go build -o ./bin/xk github.com/exekube/exekube/cli

# ------------------------------------------------------------------------------
# Second stage: getting all runtime deps
# ------------------------------------------------------------------------------
FROM alpine:3.8

# Terragrunt cache directory
ENV TERRAGRUNT_DOWNLOAD /tmp/.terragrunt-cache

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        openssl \
        tar \
        ca-certificates \
        apache2-utils \
        tzdata \
        jq \
        gnupg \
        ruby \
        ruby-json

ENV GOOGLE_CLOUD_MONITORING_VERSION 0.29.2
ENV GOOGLE_CLOUD_LOGGING_VERSION 1.5.7
RUN apk --no-cache add \
        g++ \
        make \
        ruby-dev && \
    gem install --no-ri google-protobuf:3.6.1 etc grpc --platform=ruby && \
    gem install --no-ri --no-rdoc rake google-cloud-monitoring:${GOOGLE_CLOUD_MONITORING_VERSION} google-cloud-logging:${GOOGLE_CLOUD_LOGGING_VERSION} && \
    apk del \
        g++ \
        make \
        ruby-dev

ENV CLOUD_SDK_VERSION 247.0.0
ENV PATH /google-cloud-sdk/bin:$PATH
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
        && ln -s /lib /lib64 \
        && gcloud config set core/disable_usage_reporting true \
        && gcloud config set component_manager/disable_update_check true \
        && gcloud config set metrics/environment github_docker_image \
        && gcloud --version \
        && gcloud components install alpha beta \
        && gcloud components update \
        && gcloud config set component_manager/disable_update_check true \
        && rm -rf /google-cloud-sdk/.install/.backup

ENV KUBECTL_VERSION 1.13.8
RUN curl -L -o kubectl \
        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod 0700 kubectl \
        && mv kubectl /usr/bin

ENV HELM_VERSION 2.13.1
RUN curl -L -o helm.tar.gz \
        https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -xvzf helm.tar.gz \
        && rm -rf helm.tar.gz \
        && chmod 0700 linux-amd64/helm \
        && mv linux-amd64/helm /usr/bin

ENV TERRAFORM_VERSION 0.11.14
RUN curl -o ./terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

ENV TERRAGRUNT_VERSION 0.18.6
RUN curl -L -o ./terragrunt \
        https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
        && chmod 0700 terragrunt \
        && mv terragrunt /usr/bin

ENV HELMFILE_VERSION 0.54.2
RUN curl -L -o helmfile \
        https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 \
        && chmod 0700 helmfile \
        && mv helmfile /usr/bin

ENV ISTIOCTL_VERSION 1.0.6
RUN curl -L -o istio.tar.gz \
        https://github.com/istio/istio/releases/download/${ISTIOCTL_VERSION}/istio-${ISTIOCTL_VERSION}-linux.tar.gz \
        && tar -xzvf istio.tar.gz \
        && chmod 0700 istio-${ISTIOCTL_VERSION}/bin/istioctl \
        && mv istio-${ISTIOCTL_VERSION}/bin/istioctl /usr/bin \
        && rm -rf istio.tar.gz istio-${ISTIOCTL_VERSION}

COPY terraform-plugins /terraform-plugins/

RUN cd /terraform-plugins \
    && terraform init \
    && find /terraform-plugins \
    && mkdir -p /root/.terraform.d/plugins \
    && cp /terraform-plugins/.terraform/plugins/linux_amd64/terraform-provider* /root/.terraform.d/plugins/ \
    && cd \
    && rm -fr /terraform-plugins

COPY modules /exekube-modules/
COPY --from=builder /build/bin/xk /usr/local/bin/
ENV PATH /exekube-modules/gcp-project-init:/exekube-modules/gcp-secret-mgmt/scripts:$PATH

ENTRYPOINT ["/usr/local/bin/xk"]
