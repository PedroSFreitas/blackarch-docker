FROM archlinux/base
MAINTAINER psf

USER root
ENV HOME /root
WORKDIR /root

RUN echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && \
    mkdir -p /usr/lib/ && \
    echo 'ME="BlackArch Linux"' > /usr/lib/os-release && \
    echo 'PRETTY_NAME="BlackArch Linux"' >> /usr/lib/os-release && \
    echo 'ID=blackarch' >> /usr/lib/os-release && \
    echo 'ID_LIKE=blackarch' >> /usr/lib/os-release && \
    echo 'ANSI_COLOR="0;36"' >> /usr/lib/os-release && \
    echo 'HOME_URL="https://www.blackarch.org/"' >> /usr/lib/os-release && \
    echo 'SUPPORT_URL="https://www.blackarch.org/"' >> /usr/lib/os-release && \
    ln -sfv /usr/lib/os-release /etc/os-release && \
    pacman -Syu --noconfirm --needed && \
    pacman -S --noconfirm --needed base-devel && \
    curl -s https://blackarch.org/strap.sh | sed 's|  check_internet|  #check_internet|' | sh && \
    pacman -S --noconfirm --needed \
        gcc gdb git gnu-netcat grml-zsh-config vim lib32-gcc-libs p7zip peda python pwndbg \
        pwntools radare2 rsync searchsploit tmux unrar unzip wget whois xsel xz zip zsh tar \
        zsh-completions && \
    echo 'source /usr/share/peda/peda.py' >> /root/.gdbinit && \
    echo 'e asm.syntax = att' >> /root/radare2rc && \
    chsh -s /bin/zsh root

CMD ["/bin/zsh"]
