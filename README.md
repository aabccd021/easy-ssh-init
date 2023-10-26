# easy-ssh-init
Initialize server's ssh setting using `~/.ssh/config`.

## Example

Assume you have a newly installed server 
- at 192.168.1.1
- only root user exists
- can `ssh root@192.168.1.1` using password

Given `~/.ssh/config` on your local machine:
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
- user `gh` and it's home dir is created at `192.168.1.1` if not exists
- `~/.ssh/contabo` is created if not exists
- `~/.ssh/contabo-gh` is created if not exists
- `~/.ssh/contabo.pub` is copied to `192.168.1.1:/root/.ssh/authorized_keys`
- `~/.ssh/contabo-gh.pub` is copied to `192.168.1.1:/home/gh/.ssh/authorized_keys`
