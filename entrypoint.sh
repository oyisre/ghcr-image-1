#!/usr/bin/env bash
set -euo pipefail

mkdir -p /var/run/sshd
mkdir -p /home/dev/.ssh
chmod 700 /home/dev/.ssh
chown -R dev:dev /home/dev/.ssh

if [[ -n "${PUBLIC_KEY:-}" ]]; then
  echo "${PUBLIC_KEY}" > /home/dev/.ssh/authorized_keys
  chmod 600 /home/dev/.ssh/authorized_keys
  chown dev:dev /home/dev/.ssh/authorized_keys
fi

ssh-keygen -A

echo "Starting sshd"
exec /usr/sbin/sshd -D -e
