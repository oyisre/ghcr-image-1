#!/usr/bin/env bash
set -euo pipefail

mkdir -p /var/run/sshd
mkdir -p /home/dev/.ssh
chmod 700 /home/dev/.ssh
chown -R dev:dev /home/dev/.ssh

AUTHORIZED_KEYS_INPUT="${SSH_PUBLIC_KEY:-${PUBLIC_KEY:-}}"

if [[ -n "${AUTHORIZED_KEYS_INPUT}" ]]; then
  printf '%s\n' "${AUTHORIZED_KEYS_INPUT}" | sed 's/\r$//' > /home/dev/.ssh/authorized_keys
  chmod 600 /home/dev/.ssh/authorized_keys
  chown dev:dev /home/dev/.ssh/authorized_keys
fi

ssh-keygen -A

echo "Starting sshd"
exec /usr/sbin/sshd -D -e
