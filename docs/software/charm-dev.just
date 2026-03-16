

IPADDR := `ip -4 -j route get 2.2.2.2 | jq -r '.[] | .prefsrc'`


default: _ipv6off _upgrade juju default-models starcraft


_ipv6off:
    # Disable IPv6
    grep -qxF 'net.ipv6.conf.all.disable_ipv6=1' /etc/sysctl.conf || echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf
    grep -qxF 'net.ipv6.conf.default.disable_ipv6=1' /etc/sysctl.conf || echo 'net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
    grep -qxF 'net.ipv6.conf.lo.disable_ipv6=1' /etc/sysctl.conf || echo 'net.ipv6.conf.lo.disable_ipv6=1' >> /etc/sysctl.conf

    sysctl -p


_upgrade:
    apt update
    DEBIAN_FRONTEND=noninteractive apt -y upgrade
    snap refresh


k8s version=1.35:
  snap install k8s --classic --channel={{version}}-classic/stable
  k8s bootstrap || echo "bootstrap failed"
  k8s status --wait-ready
  k8s enable local-storage
  k8s enable load-balancer
  k8s set load-balancer.l2-mode=true load-balancer.cidrs="{{IPADDR}}/32"
  k8s status --wait-ready

  command -v juju >/dev/null 2>&1 && k8s kubectl config view --raw | sudo -u ${SUDO_USER:-$USER} /snap/juju/current/bin/juju add-k8s ck8s --client


lxd:
  # Ref: https://github.com/canonical/setup-lxd/blob/main/action.yml
  lxd init --auto
  adduser ${SUDO_USER:-$USER} lxd


starcraft: lxd
  apt install -y gnome-keyring
  snap install --classic charmcraft
  snap install --classic rockcraft
  snap install --classic snapcraft


default-models:
  sudo -u ${SUDO_USER:-$USER} juju controllers --format=json | jq -r '.controllers | keys .[]' | grep -q '^lxd$' || sudo -u ${SUDO_USER:-$USER} juju bootstrap localhost lxd
  sudo -u ${SUDO_USER:-$USER} juju models --controller lxd --format=json | jq -r '.models | .[].name' | grep -q '^admin/welcome-lxd$' || sudo -u ${SUDO_USER:-$USER} juju add-model --controller lxd --config logging-config="<root>=WARNING; unit=DEBUG" --config update-status-hook-interval="60m" welcome-lxd
  sudo -u ${SUDO_USER:-$USER} juju controllers --format=json | jq -r '.controllers | keys .[]' | grep -q '^ck8s$' || sudo -u ${SUDO_USER:-$USER} juju bootstrap ck8s ck8s
  sudo -u ${SUDO_USER:-$USER} juju models --controller ck8s --format=json | jq -r '.models | .[].name' | grep -q '^admin/welcome-k8s$' || sudo -u ${SUDO_USER:-$USER} juju add-model --controller ck8s --config logging-config="<root>=WARNING; unit=DEBUG" --config update-status-hook-interval="60m" welcome-k8s


juju version=3.6: lxd k8s
  snap install juju --channel={{version}}/stable

  # Make sure juju directory is there
  # https://bugs.launchpad.net/juju/+bug/1995697
  sudo -u ${SUDO_USER:-$USER} mkdir -p /home/${SUDO_USER:-$USER}/.local/share/juju

