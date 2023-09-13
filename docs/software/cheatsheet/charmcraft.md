# Charmcraft

## Publish a charm to charmhub

Publishing to charmhub is straightforward: all you need to do is follow the
register-upload-release workflow.

<!--more-->

Note: in [headless](https://github.com/jaraco/keyring#using-keyring-on-headless-linux-systems)
environments (e.g. multipass), use this:

```bash
dbus-run-session -- bash -c "echo password | gnome-keyring-daemon --unlock; charmcraft <args>"
```


### Register a new charm's name under your account

```bash
charmcraft names
charmcraft register karma-k8s
```

### Pack and upload charm

```bash
charmcraft pack
charmcraft upload karma-k8s_ubuntu-20.04-amd64.charm
charmcraft revisions karam-k8s
```

### Upload resource (e.g. OCI image)

```bash
charmcraft resources karma-k8s
charmcraft status karma-k8s
```

```bash
docker pull ghcr.io/prymitive/karma:v0.92
IMAGE_ID=$(docker images -q ghcr.io/prymitive/karma:v0.92)
charmcraft upload-resource karma-k8s karma-image --image=$IMAGE_ID
charmcraft resource-revisions karma-k8s karma-image
```

```bash
IMAGE="docker://ghcr.io/prymitive/karma:v0.114"
DIGEST=$(skopeo inspect $IMAGE | jq -r '.Digest')

CHARM="karma-k8s"
RESOURCE="karma-image"
charmcraft upload-resource $CHARM $RESOURCE --image=$DIGEST
```

### Release

```bash
charmcraft release karma-k8s --channel=edge --revision=1 --resource=karma-image:1
charmcraft status karma-k8s
```

## Publish a bundle to charmhub

```bash
charmcraft names
charmcraft register lma-light
charmcraft revisions lma-light

charmcraft pack
charmcraft upload lma-light.zip
charmcraft revisions lma-light

charmcraft release lma-light --channel=edge --revision=1
charmcraft status lma-light
```

## Publish a library
```bash
charmcraft list-lib alertmanager-k8s

# The next command may overwrite existing files, so backup first
charmcraft create-lib alertmanager_remote_configuration

charmcraft publish-lib charms.alertmanager_k8s.v0.alertmanager_remote_configuration
```

See [official docs](https://juju.is/docs/sdk/charmcraft-libraries).

