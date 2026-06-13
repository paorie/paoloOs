#!/bin/bash

set -ouex pipefail

## 1. DNF5 Speedup
sed -i '/^\[main\]/a max_parallel_downloads=10' /etc/dnf/dnf.conf

## 2. System apps, Virtualization & udisks2
# Inserito udisks2 tra i pacchetti nativi di sistema
dnf -y install libvirt virt-manager qemu-kvm flatpak-builder wlr-randr iotop sysstat lxqt-openssh-askpass lxpolkit parallel just seahorse udisks2

## 3. Terminale agnostico (utile su Niri) & codec multimediali
dnf -y install kitty
#dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#dnf -y install ffmpeg x264-libs libva-utils --allowerasing

## 4. Installazione di Niri Window Manager
#dnf -y install niri bibata-cursor-theme

## 5. Installazione di DMS-Greeter & Greetd (Tramite COPR)
#curl --output-dir "/etc/yum.repos.d/" \
#  --remote-name "https://copr.fedorainfracloud.org/coprs/avengemedia/dms/repo/fedora-$(rpm -E %fedora)/avengemedia-dms-fedora-$(rpm -E %fedora).repo"
#dnf -y install quickshell dms greetd dms-greeter --allowerasing 

## 6. Configurazione di Greetd come Display Manager predefinito (Sostituisce SDDM)
#mkdir -p /etc/greetd/
#cat > /etc/greetd/config.toml << EOF
#[terminal]
#vt = 1
#[default_session]
#user = "greeter"
#command = "dms-greeter --command niri"
#EOF

# Forziamo il cambio del display manager disattivando SDDM a favore di Greetd
#rm -f /etc/systemd/system/display-manager.service
#ln -s /usr/lib/systemd/system/greetd.service /etc/systemd/system/display-manager.service
#systemctl enable --force greetd.service

## 7. Setup dei file di configurazione utente (Skel)
#mkdir -p /etc/skel/.config/systemd/user/graphical-session.target.wants
#ln -s /usr/lib/systemd/user/dms.service /etc/skel/.config/systemd/user/graphical-session.target.wants/
#mkdir -p /etc/skel/.config/niri/
#cp -rf /ctx/dot_config/niri/config.kdl /etc/skel/.config/niri/

## 8. Servizi di sistema e pulizia componenti
systemctl enable podman.socket

#dnf -y remove waybar

# Rigenerazione degli schemi glib
glib-compile-schemas /usr/share/glib-2.0/schemas/

## 9. CLEAN UP
dnf5 -y clean all
rm -rf /run/dnf /run/selinux-policy
rm -rf /var/lib/dnf
