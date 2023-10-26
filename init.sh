#!/bin/sh

if [ -z "$1" ]; then
  echo "hostname required"
  echo "usage: $0 <hostname>"
  exit 1
fi

set -eu
target_hostname="$1"

hosts=$(grep -E "^Host " ~/.ssh/config | sed 's/Host //')

for host in $hosts; do

  hostname=$(ssh -G "$host" | grep "^hostname " | awk '{print $2}')
  if [ "$hostname" != "$target_hostname" ]; then
    continue
  fi

  user=$(ssh -G "$host" | grep "^user " | awk '{print $2}')
  if [ "$user" != "root" ]; then
    continue
  fi

  root_identityfile=$(ssh -G "$host" \
    | grep "^identityfile " \
    | awk '{print $2}'\
    | sed "s#^~#$HOME#"\
  )
done

if [ -z "$root_identityfile" ]; then
  echo "Error: no root user found for HostName $target_hostname" 1>&2
  exit 1
fi

echo "Configuring root"
if [ ! -f "$root_identityfile" ]; then
  ssh-keygen -t ed25519 -f "$root_identityfile" -q -N ""
fi
ssh-copy-id -i "$root_identityfile" "root@$target_hostname"

for host in $hosts; do

  hostname=$(ssh -G "$host" | grep "^hostname " | awk '{print $2}')
  if [ "$hostname" != "$target_hostname" ]; then
    continue
  fi

  user=$(ssh -G "$host" | grep "^user " | awk '{print $2}')
  if [ "$user" = "root" ]; then
    continue
  fi
  if [ -z "$user" ]; then
    continue
  fi

  identityfile=$(ssh -G "$host" \
    | grep "^identityfile " \
    | awk '{print $2}'\
    | sed "s#^~#$HOME#"\
  )
  if [ -z "$identityfile" ]; then
    continue
  fi
  if [ ! -f "$identityfile" ]; then
    ssh-keygen -t ed25519 -f "$identityfile" -q -N ""
  fi

  echo "Configuring Host $host"

  ssh -i "$root_identityfile" "root@$hostname" "
    id $user &>/dev/null || useradd -m $user # create user if not exists
    mkdir -p /home/$user/.ssh
    cat >> /home/$user/.ssh/authorized_keys
  " < "$identityfile.pub"

done
