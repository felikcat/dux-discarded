#!/bin/bash
set +H
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}" && GIT_DIR=$(git rev-parse --show-toplevel)
source "${GIT_DIR}/scripts/GLOBAL_IMPORTS.sh"
source "${GIT_DIR}/configs/settings.sh"

if ! grep -q "trinity/archlinux" /etc/pacman.conf; then
    cat << 'EOF' >> /etc/pacman.conf

[trinity]
Server = https://mirror.ppa.trinitydesktop.org/trinity/archlinux/x86_64
EOF
    # Lazily done.
    curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xd6d6faa25e9a3e4ecd9fbdbec93af1698685ad8b" -o /home/"${WHICH_USER}"/trinity_key_tmp.gpg
    pacman-key --add /home/"${WHICH_USER}"/trinity_key_tmp.gpg
    rm -f /home/"${WHICH_USER}"/trinity_key_tmp.gpg
    pacman-key --lsign-key D6D6FAA25E9A3E4ECD9FBDBEC93AF1698685AD8B
fi

_setup_tdm() {
	systemctl disable entrance.service gdm.service lightdm.service lxdm.service xdm.service sddm.service >&/dev/null || :
	SERVICES+="tdm.service "
}

PKGS+="tde-tdebase tde-dbus-tqt tde-twin-style-crystal tde-twin-style-dekorator pcmanfm-qt kvantum qt6-svg qt5ct qt6ct \
brightnessctl "

_rice_tde() {
    if ! grep -q "qt5ct" /home/"${WHICH_USER}/.zprofile"; then
        cat << 'EOF' >> /home/"${WHICH_USER}"/.zprofile
export QT_QPA_PLATFORMTHEME=qt5ct
# Fixes some programs opening very slowly.
dbus-update-activation-environment --systemd --all
EOF
    fi

    mkdir "${mkdir_flags}" /home/"${WHICH_USER}"/.config/{gtk-4.0,Kvantum,qt5ct,qt6ct}
    \cp "${cp_flags}" "${GIT_DIR}"/files/home/.config/gtk-4.0/settings.ini "/home/${WHICH_USER}/.config/gtk-4.0/"
    \cp "${cp_flags}" "${GIT_DIR}"/files/home/.config/qt5ct/qt5ct.conf "/home/${WHICH_USER}/.config/qt5ct/"
    \cp "${cp_flags}" "${GIT_DIR}"/files/home/.config/qt6ct/qt6ct.conf "/home/${WHICH_USER}/.config/qt6ct/"
    kwriteconfig5 --file /home/"${WHICH_USER}"/.config/Kvantum/kvantum.kvconfig --group "General" --key "theme" "KvGnomeAlt"
}

_pkgs_add
_setup_tdm
_rice_tde

# shellcheck disable=SC2086
_systemctl enable ${SERVICES}
