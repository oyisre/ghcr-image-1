FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    sudo \
    ca-certificates \
    git \
    curl \
    wget \
    less \
    vim \
    htop \
    unzip \
    zip \
    cmake \
    build-essential \
    perl \
    python3 \
    python3-pip \
    python3-venv \
    iproute2 \
    iputils-ping \
    net-tools \
    pciutils \
    libx11-dev \
    libxi-dev \
    libxcursor-dev \
    libasound2-dev \
    libvulkan-dev \
    vulkan-tools \
    xvfb \
    tmux \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd \
 && useradd -m -s /bin/bash dev \
 && usermod -aG sudo dev \
 && mkdir -p /home/dev/.ssh \
 && chown -R dev:dev /home/dev/.ssh \
 && chmod 700 /home/dev/.ssh

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
 && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
 && sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config || true

RUN curl -LsSf https://astral.sh/uv/0.10.9/install.sh | env UV_UNMANAGED_INSTALL="/usr/local/bin" sh

LABEL org.opencontainers.image.source="https://github.com/oyisre/ghcr-image-1"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
