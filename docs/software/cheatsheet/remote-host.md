# Remote host

## Date and time

```bash
timedatectl list-timezones
sudo timedatectl set-timezone <timezone>
```

## Scheduled tasks

```bash
systemctl list-timers

```

## journalctl
```shell
journalctl --since 08:55:00 --no-pager | less
```

## sysstat
Install sysstat
```shell
sudo apt install sysstat
sed -i 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat
systemctl restart sysstat sysstat-collect.timer sysstat-summary.timer
```

Then inspect:

```shell
sar -r -q -f /var/log/sysstat/{sa_for_that_day} -s 17:50:01 -e 18:01:01
```

## Unexpected pod restarts
Get restart count per pod:
```bash
kubectl -n $namespace get pods \
  -o=jsonpath='{range .items[*]}{range .status.containerStatuses[*]}{.name}{" "}{.restartCount}{"\n"}{end}{end}' \
  | grep -v charm
```
or:
```commandline
kubectl -n cos-lite-load-test get pods -o=jsonpath='{"{"}{range .items[*]}{"\""}{.metadata.name}{"\":{"}{range .status.containerStatuses[*]}{"\""}{.name}{"\":"}{.restartCount}{","}{end}{"},"}{end}{"}"}' | sed 's/,},/},/g' | sed 's/},}/}}/g' | jq
```

Check for OOM kills:
```bash
journalctl --no-pager -kqg 'killed process' -o verbose --output-fields=MESSAGE
```

Check for node pressure eviction
```bash
journalctl | grep eviction
```

## Pod hits resource limit
This is useful to see if resource limits prevent scheduling a pod:

```shell
kubectl get pod grafana-0 -o=jsonpath='{.status}' -n test-bundle-zdsv
```

## Certs

### Verify remote certificate chain
```shell
echo | openssl s_client -strict -verify_return_error -connect charmhub.io:443 || echo "failed"
```

### View
```shell
echo | openssl s_client -showcerts -servername charmhub.io -connect charmhub.io:443 | openssl x509 -text -noout
```

### Compare
```shell
diff -y <(openssl x509 -in a.crt -text -noout) <(openssl x509 -in b.crt -text -noout)
```
