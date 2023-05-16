# SSH

Install ssh server on the server and back-up the config file:
```
sudo apt install openssh-server
sudo cp /etc/ssh/sshd_config{,.bak}
```

Update config (`/etc/ssh/sshd_config`):
```diff
-#PermitRootLogin prohibit-password
+PermitRootLogin no

-#PasswordAuthentication yes
+PasswordAuthentication no
```

Test the config before reloading:
```
sudo sshd -t -f /etc/ssh/sshd_config
```

Reload:
```
sudo systemctl reload ssh
```

Generate key pair on the client:
```
ssh-keygen -t rsa -b 4096 -f ~/secrets/tailscale-ssh -C ""
```

- `.rw------- ~/secrets/tailscale-ssh` (private key)
- `.rw-r--r-- ~/secrets/tailscale-ssh.pub` (public key)

Copy the public key to the server and update the list of authorized keys
```
cat /tmp/tailscale-ssh.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

From the client, log in to the server:
```
ssh -i ~/secrets/tailscale-ssh \                                                                                                                                                                   [±main ●●●]
  -o "UserKnownHostsFile=/dev/null" \
  -o "StrictHostKeyChecking no" \
  user@remote
```
