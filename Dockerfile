FROM redis:4.0.2-alpine

RUN apk add --no-cache curl jq openssl tar bash

# Add ContainerPilot and set its configuration file path
ENV CONTAINERPILOT_VER 3.5.0
ENV CONTAINERPILOT //etc/containerpilot.json5
RUN export CONTAINERPILOT_CHECKSUM=f06b2e8398f83ee860a73c207354b75758e3e3ac \
    && curl -Lso /tmp/containerpilot.tar.gz \
        "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
    && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz

ENV CONSUL_VER 1.0.0
ENV CONSUL_SHA256 585782e1fb25a2096e1776e2da206866b1d9e1f10b71317e682e03125f22f479
RUN curl -Lso /tmp/consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip" \
    && echo "${CONSUL_SHA256}  /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && mkdir -p /opt/consul/config

ENV CONSUL_TEMPLATE_VER 0.19.3
ENV CONSUL_TEMPLATE_SHA256 47b3f134144b3f2c6c1d4c498124af3c4f1a4767986d71edfda694f822eb7680
RUN curl -Lso /tmp/consul-template.zip "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VER}/consul-template_${CONSUL_TEMPLATE_VER}_linux_amd64.zip" \
    && echo "${CONSUL_TEMPLATE_SHA256}  /tmp/consul-template.zip" | sha256sum -c \
    && unzip -d /usr/local/bin /tmp/consul-template.zip \
    && rm /tmp/consul-template.zip

ENV CONSUL_CLI_VER 0.3.1
ENV CONSUL_CLI_SHA256 037150d3d689a0babf4ba64c898b4497546e2fffeb16354e25cef19867e763f1
RUN curl -Lso /tmp/consul-cli.tgz "https://github.com/CiscoCloud/consul-cli/releases/download/v${CONSUL_CLI_VER}/consul-cli_${CONSUL_CLI_VER}_linux_amd64.tar.gz" \
    && echo "${CONSUL_CLI_SHA256}  /tmp/consul-cli.tgz" | sha256sum -c \
    && tar zxf /tmp/consul-cli.tgz -C /usr/local/bin --strip-components 1 \
    && rm /tmp/consul-cli.tgz

COPY etc/* /etc/
COPY bin/* /usr/local/bin/

# override the parent entrypoint
ENTRYPOINT []

CMD ["containerpilot"]

