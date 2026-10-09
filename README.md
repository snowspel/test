# SNOW Dotfiles for Minimal Arch Linux
Complete Hyprland + Quickshell Modern Setup.

## Installation on Minimal Arch Linux:
1. Boot into your fresh minimal Arch Linux installation as your normal user.
2. Ensure git is installed:
   ```bash
   sudo pacman -S --noconfirm git
   ```
3. Extract this archive or clone your repo into `~/dotfiles`:
   ```bash
   # If you downloaded the zip:
   unzip snow-dotfiles.zip -d ~
   cd ~/dotfiles
   bash install.sh
   ```
4. When installation finishes, reboot:
   ```bash
   sudo reboot
   ```
5. At the SDDM login screen, choose **Hyprland** and log in!
