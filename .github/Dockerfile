FROM alpine:3.16.2

RUN apk update && \
    wget https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip && \
    unzip terraform_1.2.7_linux_amd64.zip && rm terraform_1.2.7_linux_amd64.zip && \
    mv terraform /usr/bin/terraform

