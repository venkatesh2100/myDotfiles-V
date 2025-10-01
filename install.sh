#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Detecting package manager..."
install_packages() {
  PKGS=(zsh tmux neovim git curl)

  if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt install -y "${PKGS[@]}"
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "${PKGS[@]}"
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm "${PKGS[@]}"
  elif command -v zypper &>/dev/null; then
    sudo zypper install -y "${PKGS[@]}"
  else
    echo "⚠️ Could not detect a supported package manager."
    echo "   Please install these packages manually: ${PKGS[*]}"
  fi
}

echo "==> Installing required packages..."
install_packages

echo "==> Creating config directories..."
mkdir -p "$HOME/.config/mpd"

echo "==> Linking dotfiles..."
ln -sf "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
ln -sf "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
ln -sf "$DOTFILES_DIR/wofi" "$HOME/.config/wofi"
ln -sf "$DOTFILES_DIR/swaylock" "$HOME/.config/swaylock"
ln -sf "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
ln -sf "$DOTFILES_DIR/neofetch" "$HOME/.config/neofetch"
ln -sf "$DOTFILES_DIR/rmpc" "$HOME/.config/rmpc"

# Single files
ln -sf "$DOTFILES_DIR/mpd.conf" "$HOME/.config/mpd/mpd.conf"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/xolddolphinrc" "$HOME/.xolddolphinrc"

echo "==> Setting up LazyVim..."
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  echo "LazyVim starter config cloned!"
else
  echo "⚠️ ~/.config/nvim already exists, skipping LazyVim clone."
fi

echo "==> Done! 🎉 Restart Neovim with :Lazy to install plugins."
