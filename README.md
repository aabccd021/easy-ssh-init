# easy-ssh-init
Initialize server from `~/.ssh/config`.

## Security notes
This script DOES NOT delete keys from server when you delete Host(s) in your `~/.ssh/config`.
You DO have to delete unnecessary keys manually.

## Usage
Assume you have a newly installed server on 192.168.1.1 which you can login 
using password with `ssh root@192.168.1.1`

Given this `~/.ssh/config` on your local machine:
```ssh_config
Host contabo-root
  HostName 192.168.1.1
  User root
  IdentityFile ~/.ssh/contabo
Host contabo-gh
  HostName 192.168.1.1
  User gh
  IdentityFile ~/.ssh/contabo-gh
```

You can run:
```sh
curl -sSf "https://raw.githubusercontent.com/aabccd021/easy-ssh-init/main/init.sh" | sh -s 192.168.1.1
```

The end results:
- non-root user `gh` and it's home dir is created on the server if previously absent
- `~/.ssh/contabo` is created if previously absent
- `~/.ssh/contabo-gh` is created if previously absent
- `~/.ssh/contabo.pub` is copied to `192.168.1.1:/root/.ssh/authorized_keys`
- `~/.ssh/contabo-gh.pub` is copied to `192.168.1.1:/home/gh/.ssh/authorized_keys`
- `ssh contabo` works
- `ssh contabo-gh` works

## Notes
Although you can run this script multiple times,
it's not designed to configure server in declarative (*vine boom effect*) manner, 
hence this script:
- will store duplicate `authorized_keys` when run multiple times with same `~/.ssh/config`
- will not delete keys stored in `authorized_keys` when a `Host` is deleted/modified on `~/.ssh/config`
