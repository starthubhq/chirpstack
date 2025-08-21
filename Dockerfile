# Base image
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    zip \
    gnupg \
    git \
    dnsutils \
    redis-tools \
    postgresql-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install OpenTofu
ARG TOFU_VERSION=1.6.0
ARG TARGETARCH=amd64
RUN apt-get update && apt-get install -y unzip curl ca-certificates && \
    curl -LO https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_${TARGETARCH}.zip && \
    unzip tofu_${TOFU_VERSION}_linux_${TARGETARCH}.zip && \
    mv tofu /usr/local/bin/tofu && \
    chmod +x /usr/local/bin/tofu && \
    rm tofu_${TOFU_VERSION}_linux_${TARGETARCH}.zip

ARG DOCTL_VERSION=1.109.0
RUN curl -sL https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-1.109.0-linux-amd64.tar.gz -o doctl.tar.gz && \
    tar -xzf doctl.tar.gz && \
    mv doctl /usr/local/bin/doctl && \
    chmod +x /usr/local/bin/doctl && \
    rm doctl.tar.gz

# Working directory where project gets mounted
WORKDIR /app

# Add entrypoint
COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
