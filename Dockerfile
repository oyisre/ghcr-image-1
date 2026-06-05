FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics

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
    xz-utils \
    file \
    pkg-config \
    cmake \
    ninja-build \
    build-essential \
    clang \
    lldb \
    gdb \
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
    libgl1-mesa-dev \
    libegl1 \
    mesa-utils \
    libvulkan-dev \
    vulkan-tools \
    xvfb \
    tmux \
    jq \
    ripgrep \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd \
 && useradd -m -s /bin/bash dev \
 && usermod -aG sudo dev \
 && echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev \
 && chmod 440 /etc/sudoers.d/dev \
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

WORKDIR /workspace

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
