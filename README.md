# easy-ssh-init
Initialize server ssh config from `~/.ssh/config`.

Assume you have a newly installed server on 192.168.1.1 which you can login 
using password with `ssh root@192.168.1.1`

Given this `~/.ssh/config` on your local machine:
```ssh_config
Host contabo
  User root
  HostName 192.168.1.1
  IdentityFile ~/.ssh/contabo
Host contabo-gh
  User gh
  HostName 192.168.1.1
  IdentityFile ~/.ssh/contabo-gh
```

You can run:
```
curl -sSf "https://raw.githubusercontent.com/aabccd021/easy-ssh-init/main/init.sh" | sh -s 192.168.1.1
```

End results:
- non-root user `gh` and it's home dir is created on the server if previously absent
- `~/.ssh/contabo` is created if previously absent
- `~/.ssh/contabo-gh` is created if previously absent
- `~/.ssh/contabo.pub` is copied to `192.168.1.1:/root/.ssh/authorized_keys`
- `~/.ssh/contabo-gh.pub` is copied to `192.168.1.1:/home/gh/.ssh/authorized_keys`
- `ssh contabo` works
- `ssh contabo-gh` works
