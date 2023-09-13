# SSH cheatsheet

## Access charm's web UI when they are deployed on multipass
```shell
MULTIPASS_VM_IP="10.43.8.206"  # From `multipass list`
GRAFANA_UNIT_IP="10.1.166.80"  # From `juju status`
GRAFANA_WORKLOAD_PORT="3000"   # From familiarity with the app

sudo ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking no" \
  -i /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa \
  ubuntu@$MULTIPASS_VM_IP \
  -L 8080:$GRAFANA_UNIT_IP:$GRAFANA_WORKLOAD_PORT
```

## Set up SSH server
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
