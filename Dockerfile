FROM archlinux/base
MAINTAINER psf

USER root
ENV HOME /root
WORKDIR /root

RUN echo '[multilib]' >> /etc/pacman.conf && \
    echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

RUN pacman -Syu --noconfirm --needed --force && \
    pacman -Scc --noconfirm && \
    pacman -S --force --noconfirm --needed base-devel && \
    curl -s https://blackarch.org/strap.sh | sed 's|  check_internet|  #check_internet|' | sh && \
    pacman -S --force --noconfirm --needed \
        0d1n 0trace afflib aircrack-ng arch-install-scripts autosploit base64dump bc bind-tools \
        binwalk blackarch-installer bulk-extractor cewl cfr clonezilla cloudflare-enum cppcheck \
        crunch dex2jar dirbuster dirsearch dnsrecon dnsspider dosfstools enum4linux enum-shares \
        ettercap fernflower findmyhash foremost frida gcc gdb git gnu-netcat gobuster \
        grml-zsh-config gvfs vim hash-buster hashcat hashid htop hydra iw jad john kickthemout \
        kismet lib32-gcc-libs libsecret linux-exploit-suggester.sh lsb-release lzop malwaredetect \
        masscan metasploit mimikatz mimipenguin mitmf msf-mpc mtools mutator mutt nfsshell \
        nfs-utils nikto nmap noriben nosqlmap openssh openvpn ophcrack p7zip padbuster parted peda \
        peframe perl-image-exiftool pngcheck postgresql proxychains-ng pwndbg pwntools pyrit \
        python2-yara radamsa radare2 raven reaver recon-ng rsync searchsploit set shodan smbclient \
        smbmap smtp-user-enum spiderfoot sqlmap squashfs-tools sshfs ssldump sslyze stegdetect \
        steghide stegsolve sublist3r tcpdump tcpextract tcpick testdisk theharvester tigervnc tmux \
        tor traceroute transmission-cli ttf-bitstream-vera ttf-dejavu ttf-font-awesome \
        ttf-freefont ttf-inconsolata ttf-ionicons ttf-liberation ttf-symbola unicorn-powershell \
        unicornscan unrar unzip vim-airline vim-airline-themes vim-nerdtree vim-tagbar volatility \
        webshells weechat wget whois wifite wireshark-cli wpscan xsel xz yara zip zsh \
        zsh-completions zsh-syntax-highlighting

RUN chsh -s /bin/zsh root
CMD ["/bin/zsh"]
