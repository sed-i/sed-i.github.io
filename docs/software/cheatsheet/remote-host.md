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
