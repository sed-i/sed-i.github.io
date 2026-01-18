# How to use this file:
# 1. First, install just (sudo snap install --classic just)
# 2. just -f <(curl -fsSL sed-i.github.io/software/26.04.just)


default: tui


tui: && _nushell _zellij _aliases
    sudo apt install -y git curl tree neovim btop htop ripgrep fd-find bat duf dasel jq yq lf


oci:
    sudo apt install -y skopeo

    # dive
    cd $(mktemp -d); \
      curl -fsSL https://github.com/wagoodman/dive/releases/download/v0.13.1/dive_0.13.1_linux_amd64.deb -o dive.deb; \
      sudo dpkg -i dive.deb; \
      cd -



# =====================================


_nushell:
    #!/usr/bin/env bash
    sudo snap install --classic nushell
    mkdir -p "$HOME/.config/nushell/"
    if [ ! -e "$HOME/.config/nushell/config.nu" ]; then
        nu -c "config nu --default" > $HOME/.config/nushell/config.nu
    fi
    if [ ! -e "$HOME/.config/nushell/env.nu" ]; then
        nu -c "config env --default" > $HOME/.config/nushell/env.nu
    fi
    grep -qxF '$env.EDITOR = "nvim"' "$HOME/.config/nushell/config.nu" || echo '$env.EDITOR = "nvim"' >> "$HOME/.config/nushell/config.nu"


_zellij:
    #!/usr/bin/env bash
    sudo snap install --classic zellij
    mkdir -p "$HOME/.config/zellij/"
    if [ ! -e "~/.config/zellij/config.kdl" ]; then
      zellij setup --dump-config > ~/.config/zellij/config.kdl
    fi
    sed -i 's/^default_shell.*$/default_shell "nu"/' "$HOME/.config/zellij/config.kdl"
    grep -qxF 'default_shell "nu"' "$HOME/.config/zellij/config.kdl" || echo 'default_shell "nu"' >> "$HOME/.config/zellij/config.kdl"


_aliases:
    #!/usr/bin/env bash
    cd $(mktemp -d)
    git clone https://github.com/sed-i/justfiles.git
    mkdir -p $HOME/.aliases
    cp -r justfiles/dotfiles/aliases/* $HOME/.aliases
    touch "$HOME/.bash_aliases"
    for f in $HOME/.aliases/*.sh; do
      rel_f=$(echo "$f" | sed "s|^$HOME|~|")
      echo "Adding bash aliases: ${rel_f}"
      grep -qxF ". ${rel_f}" "$HOME/.bash_aliases" || echo ". ${rel_f}" >> "$HOME/.bash_aliases"
    done

    for f in ~/.aliases/*.nu; do
      rel_f=$(echo "$f" | sed "s|^$HOME|~|")
      echo "Adding nu aliases: ${rel_f}"
      grep -qxF "source ${rel_f}" "$HOME/.config/nushell/config.nu" || echo "source ${rel_f}" >> "$HOME/.config/nushell/config.nu"
    done
