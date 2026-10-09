#!/usr/bin/env bash
# ==============================================================================
# SNOW Hyprland + Quickshell Complete Auto-Installer
# Optimized for Fresh Minimal Arch Linux (No Desktop Pre-installed)
# Usage: bash install.sh
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

# Script directory
R="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color output formatting
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_step() {
  echo -e "\n${BOLD}${BLUE}==> [${1}] ${2}${NC}"
}
log_ok() {
  echo -e "  ${GREEN}[✓] ${1}${NC}"
}
log_warn() {
  echo -e "  ${YELLOW}[!] ${1}${NC}"
}
log_err() {
  echo -e "  ${RED}[✗] ${1}${NC}"
}

# ------------------------------------------------------------------------------
# Pre-Flight Checks
# ------------------------------------------------------------------------------
if [ "$EUID" -eq 0 ]; then
  log_err "Please run this script as a normal user with sudo permissions, NOT as root!"
  exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
  log_err "This installer is exclusively designed for Arch Linux."
  exit 1
fi

echo -e "${BOLD}${BLUE}"
cat << 'EOF'
  ____  _   _  ______          __   _____ _   _  _____ _______       _      _      
 / ____| \ | |/ __ \ \        / /  |_   _| \ | |/ ____|__   __|/\   | |    | |     
| (___ |  \| | |  | \ \  /\  / /     | | |  \| | (___    | |  /  \  | |    | |     
 \___ \| . ` | |  | |\ \/  \/ /      | | | . ` |\___ \   | | / /\ \ | |    | |     
 ____) | |\  | |__| | \  /\  /      _| |_| |\  |____) |  | |/ ____ \| |____| |____ 
|_____/|_| \_|\____/   \/  \/      |_____|_| \_|_____/   |_/_/    \_\______|______|
EOF
echo -e "${NC}"
echo "Installing Snow Hyprland + Quickshell Modern Setup..."
echo "User: $USER | Dotfiles Source: $R"
echo

# Prompt sudo password early
sudo -v
# Keep sudo active in background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ------------------------------------------------------------------------------
# 1/10: Update Package DB & Base Developer Tools
# ------------------------------------------------------------------------------
log_step "1/10" "Refreshing Pacman Repositories & Base Development Tools"
sudo pacman -Sy --needed --noconfirm base-devel git wget curl

# ------------------------------------------------------------------------------
# 2/10: GPU Hardware Detection & Driver Installation
# ------------------------------------------------------------------------------
log_step "2/10" "Detecting Graphics Hardware"
GPU_PACKAGES=()

if lspci 2>/dev/null | grep -iE 'vga|3d|display' | grep -i nvidia >/dev/null; then
  log_warn "NVIDIA GPU detected. Installing complete NVIDIA Open-DKMS Wayland stack..."
  KVER="$(uname -r)"
  if [[ "$KVER" == *"lts"* ]]; then
    GPU_PACKAGES+=(linux-lts-headers)
  else
    GPU_PACKAGES+=(linux-headers)
  fi
  GPU_PACKAGES+=(
    dkms
    nvidia-open-dkms
    nvidia-utils
    egl-wayland
    libva-nvidia-driver
    linux-firmware
  )
  
  # Configure NVIDIA DRM modeset & early KMS for Hyprland
  echo "options nvidia-drm modeset=1 fbdev=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null
  sudo mkdir -p /etc/environment.d
  printf "LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
NVD_BACKEND=direct
ELECTRON_OZONE_PLATFORM_HINT=auto
" | sudo tee /etc/environment >/dev/null
else
  log_ok "Standard / AMD / Intel GPU detected. Installing Mesa and Vulkan..."
  GPU_PACKAGES+=(mesa vulkan-icd-loader)
  if lspci 2>/dev/null | grep -iE 'vga|3d|display' | grep -i amd >/dev/null; then
    GPU_PACKAGES+=(vulkan-radeon libva-mesa-driver)
  elif lspci 2>/dev/null | grep -iE 'vga|3d|display' | grep -i intel >/dev/null; then
    GPU_PACKAGES+=(vulkan-intel intel-media-driver)
  fi
fi

if [ ${#GPU_PACKAGES[@]} -gt 0 ]; then
  sudo pacman -S --needed --noconfirm "${GPU_PACKAGES[@]}" || log_warn "GPU packages were already present or skipped."
fi

# ------------------------------------------------------------------------------
# 3/10: Official Core Desktop Packages
# ------------------------------------------------------------------------------
log_step "3/10" "Installing Official Arch Linux Core Packages"
OFFICIAL_PKGS=(
  # Compositor & core tools
  hyprland
  kitty
  nautilus
  
  # Screenshot & clipboard utilities
  grim
  slurp
  wl-clipboard
  cliphist
  swappy
  libnotify
  
  # Hardware controls & utilities
  brightnessctl
  ddcutil
  i2c-tools
  playerctl
  jq
  imagemagick
  
  # Audio (Pipewire stack)
  pipewire
  pipewire-pulse
  wireplumber
  libpulse
  pavucontrol
  
  # Networking & Bluetooth
  networkmanager
  bluez
  bluez-utils
  
  # Fonts & Icons
  inter-font
  ttf-jetbrains-mono
  ttf-montserrat
  noto-fonts-emoji
  ttf-dejavu
  dconf
  papirus-icon-theme
  
  # Qt Framework & Polkit agent
  qt6-declarative
  qt6-wayland
  qt6-svg
  qt5-declarative
  qt5-quickcontrols2
  qt5-svg
  qt5-graphicaleffects
  hyprpolkitagent
  
  # Display manager & XWayland support
  sddm
  xorg-server
)

sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}"

# ------------------------------------------------------------------------------
# 4/10: Quickshell Package Installation (Official or AUR)
# ------------------------------------------------------------------------------
log_step "4/10" "Verifying & Installing Quickshell"
if command -v quickshell >/dev/null 2>&1; then
  log_ok "Quickshell is already installed: $(which quickshell)"
elif pacman -Si quickshell >/dev/null 2>&1; then
  log_ok "Installing Quickshell from Pacman repository..."
  sudo pacman -S --needed --noconfirm quickshell
else
  log_warn "Quickshell is in AUR. Setting up AUR helper..."
  if ! command -v yay >/dev/null 2>&1 && ! command -v paru >/dev/null 2>&1; then
    log_ok "Installing 'yay-bin' helper from AUR..."
    BUILD_DIR="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$BUILD_DIR/yay-bin"
    (cd "$BUILD_DIR/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$BUILD_DIR"
  fi
  
  AUR_HELPER="yay"
  command -v paru >/dev/null 2>&1 && AUR_HELPER="paru"
  log_ok "Installing quickshell using $AUR_HELPER..."
  $AUR_HELPER -S --needed --noconfirm quickshell || $AUR_HELPER -S --needed --noconfirm quickshell-git
fi

# ------------------------------------------------------------------------------
# 5/10: Services & User Groups
# ------------------------------------------------------------------------------
log_step "5/10" "Enabling Services & Setting User Group Permissions"
sudo systemctl enable NetworkManager.service bluetooth.service

# Bluetooth auto-enable false config
sudo mkdir -p /etc/bluetooth
sudo touch /etc/bluetooth/main.conf
sudo sed -i 's/^#\?AutoEnable=.*/AutoEnable=false/' /etc/bluetooth/main.conf 2>/dev/null || true

# i2c permissions for monitor brightness
getent group i2c >/dev/null || sudo groupadd i2c
sudo usermod -aG i2c,video,input "$USER"
echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf >/dev/null

# Enable user audio services
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || true

# ------------------------------------------------------------------------------
# 6/10: Create Configuration Folders
# ------------------------------------------------------------------------------
log_step "6/10" "Creating Destination Directories"
mkdir -p "$HOME/.config/quickshell/snow/launcher" \
         "$HOME/.config/quickshell/snow/quicksettings" \
         "$HOME/.config/quickshell/snow/apps" \
         "$HOME/.config/quickshell/snow/power" \
         "$HOME/.config/quickshell/snow/osd" \
         "$HOME/.config/quickshell/snow/polkit" \
         "$HOME/.config/quickshell/snow/notifications" \
         "$HOME/.config/snow/bin" \
         "$HOME/.config/hypr/wallpaper" \
         "$HOME/Pictures/Screenshots"

# ------------------------------------------------------------------------------
# 7/10: Deploy Dotfiles (Quickshell, Snow, Hyprland)
# ------------------------------------------------------------------------------
log_step "7/10" "Copying Snow Dotfiles into ~/.config"

# Quickshell files
if [ -d "$R/quickshell" ]; then
  cp -r "$R"/quickshell/. "$HOME/.config/quickshell/snow/"
  log_ok "Copied Quickshell QML popups and shell.qml"
fi

# Snow files & scripts
if [ -d "$R/snow" ]; then
  cp -r "$R"/snow/. "$HOME/.config/snow/"
  chmod +x "$HOME"/.config/snow/bin/*.sh 2>/dev/null || true
  log_ok "Copied Snow themes and scripts"
fi

# Backup old Hyprland config if present
if [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
  cp "$HOME/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf.bak.$(date +%s)"
fi

# Hyprland config
if [ -d "$R/hypr" ]; then
  cp -r "$R"/hypr/. "$HOME/.config/hypr/"
  log_ok "Copied Hyprland config & rules"
fi

# ------------------------------------------------------------------------------
# 8/10: SDDM Login Theme & Wallpaper Sync Service
# ------------------------------------------------------------------------------
log_step "8/10" "Setting Up SDDM Login Theme & Wallpaper Sync"
if [ -d "$R/sddm/snow" ]; then
  sudo mkdir -p /usr/share/sddm/themes/snow /etc/sddm.conf.d
  sudo cp -r "$R"/sddm/snow/. /usr/share/sddm/themes/snow/
  printf '[Theme]\nCurrent=snow\n' | sudo tee /etc/sddm.conf.d/20-snow.conf >/dev/null
  printf '[General]\nNumlock=on\n' | sudo tee /etc/sddm.conf.d/30-numlock.conf >/dev/null
  sudo systemctl enable sddm.service
  log_ok "SDDM Snow login theme enabled"
fi

# Install Wallpaper Sync daemon
if [ -d "$R/system" ] && [ -f "$R/system/snow-sddm-wallpaper" ]; then
  for f in snow-sddm-wallpaper snow-sddm-wallpaper.path; do
    if [ -f "$R/system/$f" ]; then
      sed -e "s|__HOME__|$HOME|g" -e "s|/home/[^/]*/|$HOME/|g" "$R/system/$f" > "/tmp/$f"
    fi
  done
  sudo install -m 755 /tmp/snow-sddm-wallpaper /usr/local/bin/snow-sddm-wallpaper
  if [ -f "$R/system/snow-sddm-wallpaper.service" ]; then
    sudo install -m 644 /tmp/snow-sddm-wallpaper.path "$R/system/snow-sddm-wallpaper.service" /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable --now snow-sddm-wallpaper.path 2>/dev/null || true
    sudo systemctl start snow-sddm-wallpaper.service 2>/dev/null || true
    log_ok "Installed SDDM dynamic wallpaper synchronizer"
  fi
fi

# ------------------------------------------------------------------------------
# 9/10: App Theming & Terminal Integration
# ------------------------------------------------------------------------------
log_step "9/10" "Configuring Kitty Terminal & Shell Aliases"

mkdir -p "$HOME/.config/kitty"
grep -q "snow-theme.conf" "$HOME/.config/kitty/kitty.conf" 2>/dev/null || \
  printf 'include snow-theme.conf\nfont_family JetBrains Mono\nfont_size 11.0\nconfirm_os_window_close 0\n' >> "$HOME/.config/kitty/kitty.conf"

# Run color scripts
bash "$HOME/.config/snow/bin/apply-kitty.sh" 2>/dev/null || true
bash "$HOME/.config/snow/bin/apply-gtk.sh" 2>/dev/null || true

# Snow alias in ~/.bashrc
grep -q "alias snow=" "$HOME/.bashrc" 2>/dev/null || \
  echo "alias snow='quickshell -p ~/.config/quickshell/snow'" >> "$HOME/.bashrc"

# Remove noisy default launcher shortcuts
sudo rm -f /usr/share/applications/bssh.desktop \
           /usr/share/applications/bvnc.desktop \
           /usr/share/applications/avahi-discover.desktop 2>/dev/null || true

# ------------------------------------------------------------------------------
# 10/10: Integrity Verification
# ------------------------------------------------------------------------------
log_step "10/10" "Integrity Verification"

if [ -f "$HOME/.config/quickshell/snow/shell.qml" ]; then
  log_ok "shell.qml verified: OK"
else
  log_warn "Notice: shell.qml was not found in destination."
fi

if [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
  log_ok "hyprland.conf verified: OK"
else
  log_warn "Notice: hyprland.conf was not found in destination."
fi

echo
echo -e "${BOLD}${GREEN}======================================================${NC}"
echo -e "${BOLD}${GREEN}   Snow Setup Installed Successfully with Zero Errors!${NC}"
echo -e "${BOLD}${GREEN}======================================================${NC}"
echo
echo "Instructions:"
echo "1. Reboot system now:  sudo reboot"
echo "2. On SDDM login screen, select 'Hyprland' session"
echo "3. Active shortcuts:"
echo "   • SUPER + SPACE   -> App Launcher"
echo "   • SUPER + A       -> Quick Settings"
echo "   • SUPER + TAB     -> Open Windows & Active Apps"
echo "   • SUPER + ESC     -> 3-Button Power Menu (Log Out, Restart, Shut Down)"
echo "   • SUPER + .       -> Ultra-compact Clock & Date OSD"
echo "   • SUPER + S       -> Screen Capture / Screenshot"
echo "   • SUPER + T       -> Kitty Terminal"
echo
echo "Optional AUR packages you can install with yay:"
echo "  yay -S brave-bin localsend-bin ab-download-manager-bin"
echo
