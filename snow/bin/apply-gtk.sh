#!/usr/bin/env bash
# ~/.config/snow/bin/apply-gtk.sh
# Applies Dark mode, Papirus icons and Inter font
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface font-name 'Inter 10' 2>/dev/null || true
