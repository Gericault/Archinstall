#!/bin/bash

# Arch Linux Minimal Wayland Setup with Sway

# Ensures the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo' or login as root."
    exit 1
fi

# Update the system first
echo "Updating system..."
pacman -Syu --noconfirm

# =============================================
# Package Installation Sections
# =============================================

# --------------------------
# Essential System Packages
# --------------------------
echo "Installing essential system packages..."
pacman -S --noconfirm --needed \
    base-devel \
    git \
    linux-headers \
    ntfs-3g \
    fuse \
    bash-completion \
    networkmanager \
    ufw \
    sof-firmware \
    man-db man-pages \
    htop

# Enable NetworkManager
systemctl enable NetworkManager
systemctl start NetworkManager

# Enable firewall (UFW)
systemctl enable ufw
systemctl start ufw
ufw enable

# --------------------------
# NVIDIA Drivers
# --------------------------
echo "Installing NVIDIA drivers..."
pacman -S --noconfirm --needed \
    nvidia \
    nvidia-utils \
    nvidia-settings \
    lib32-nvidia-utils \
    lib32-opencl-nvidia \
    opencl-nvidia

# --------------------------
# Wayland and Sway
# --------------------------
echo "Installing Wayland and Sway..."
pacman -S --noconfirm --needed \
    wayland \
    sway \
    swaybg \            # Wallpaper utility
    swayidle \          # Idle management
    swaylock \          # Screen locker
    wl-clipboard \      # Clipboard support
    foot \              # Wayland-native terminal
    nnn \               # Terminal file manager
    grim \              # Screenshot utility
    slurp \             # Region selection for screenshots
    mako \              # Notification daemon
    polkit \            # Authentication agent
    seatd \             # Seat management daemon
    xdg-desktop-portal \ # Desktop integration
    xdg-desktop-portal-wlr # Wayland integration

# Enable seatd for permission handling
systemctl enable --now seatd

# --------------------------
# Audio
# --------------------------
echo "Installing audio packages..."
pacman -S --noconfirm --needed \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pavucontrol \
    alsa-utils

# --------------------------
# Fonts
# --------------------------
echo "Installing minimal fonts..."
pacman -S --noconfirm --needed \
    ttf-dejavu \
    noto-fonts \
    noto-fonts-emoji \
    ttf-jetbrains-mono

# --------------------------
# AUR Helper (yay) and Spotify
# --------------------------
echo "Installing yay AUR helper..."
pacman -S --noconfirm --needed go
sudo -u $SUDO_USER bash -c 'git clone https://aur.archlinux.org/yay.git /tmp/yay'
sudo -u $SUDO_USER bash -c 'cd /tmp/yay && makepkg -si --noconfirm'
rm -rf /tmp/yay

echo "Installing Spotify..."
sudo -u $SUDO_USER bash -c 'yay -S --noconfirm spotify'

# --------------------------
# Applications
# --------------------------
echo "Installing essential applications..."
pacman -S --noconfirm --needed \
    obsidian \
    keepassxc \
    firefox \           # Wayland-native browser
    discord \
    kitty \             # Can be used with XWayland
    mpv \
    ffmpeg

# =============================================
# Post-Installation Notes
# =============================================
echo ""
echo "Installation complete!"
echo "Important next steps:"
echo "1. Reboot your system"
echo "2. Add 'exec sway' to your ~/.bash_profile to start Sway automatically"
echo "3. Basic Sway usage:"
echo "   - Super+Enter: Open terminal (foot)"
echo "   - Super+Shift+q: Close window"
echo "   - Super+d: Application launcher"
echo "   - Super+Shift+e: Exit Sway"
echo ""
echo "Configuration files:"
echo "  - ~/.config/sway/config (main config)"
echo "  - ~/.config/mako/config (notifications)"
echo ""
echo "For NVIDIA on Wayland, you may need to add:"
echo "  WLR_NO_HARDWARE_CURSORS=1 to your environment variables"
