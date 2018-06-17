#!/bin/sh

# ATTENTION:
# any personal setting or configuration should be implemented in user_customize
# function. Always use full path (not relative) in the commands.
# ALSO:
# the $packages array should be changed if the user would like to install other
# packages by default.

# exit on error
set -eu

# global package variable
# packages_base holds the base packages for the system (you shouldn't change it)
# packages_security will hold the packages from blackarch to be installed.
packages_base=('zsh' 'yaourt' 'zsh-completions' 'grml-zsh-config' 'vim')
packages_security=('')

# enable multilib repository
set_pacman_conf() {
    echo '[multilib]' >> /etc/pacman.conf
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

    rm -rfv /usr/share/libalpm/hooks/package-cleanup.hook

    return 0
}

# set blackarch release information
set_blackarch_release() {
    mkdir -p /usr/lib
    echo 'ME="BlackArch Linux"' > /usr/lib/os-release
    echo 'PRETTY_NAME="BlackArch Linux"' >> /usr/lib/os-release
    echo 'ID=blackarch' >> /usr/lib/os-release
    echo 'ID_LIKE=blackarch' >> /usr/lib/os-release
    echo 'ANSI_COLOR="0;36"' >> /usr/lib/os-release
    echo 'HOME_URL="https://www.blackarch.org/"' >> /usr/lib/os-release
    echo 'SUPPORT_URL="https://www.blackarch.org/"' >> /usr/lib/os-release

    ln -sfv /usr/lib/os-release /etc/os-release

    return 0
}

# set peda (gdb) configuration
set_peda_conf() {
    echo 'source /usr/share/peda/peda.py' >> /root/.gdbinit

    return 0
}

# set radare2 configuration (at&t syntax)
set_radare_conf() {
    echo 'e asm.syntax = att' >> /root/.radare2rc

    return 0
}

# upgrade system, install blackarch repo and base-devel
pacman_update() {
    pacman -Syu --needed --noconfirm
    pacman -S base base-devel --needed --noconfirm

    curl -s https://blackarch.org/strap.sh | \
        sed 's|  check_internet|  #check_internet|' | sh

    pacman-key --populate blackarch archlinux

    return 0
}

# set zsh as default shell
set_zsh() {
    chsh -s /bin/zsh root

    return 0
}

# install packages named on $packages
install_packages() {
    if [[ -z "${packages_base[*]}" ]]; then
        echo "ERROR: packages_base array is empty!"
        return 1
    fi

    echo "Installing base packages..."
    pacman -Sy --needed --noconfirm "${packages_base[@]}"

    if [[ -z "${packages_security[*]}" ]]; then
        return 0
    fi

    echo "Installing security packages..."
    pacman -Sy --needed --noconfirm "${packages_security[@]}"

    return 0
}

# set every customization or setting in this function
user_customize() {
    return 0
}

main(){
    set_blackarch_release
    set_pacman_conf
    pacman_update
    install_packages
    set_radare_conf
    set_peda_conf
    set_zsh

    # any personal configuration or setting should be set in this function
    user_customize

    return 0
}

main "${@}"
