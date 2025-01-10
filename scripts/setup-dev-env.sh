#!/bin/bash

# Get the operating system name
OS=$(uname)

if [ "$OS" != 'Darwin' ]; then
  echo 'This script is written for macOS'
  exit 1
fi

# Check if Command Line Tools are installed
if ! xcode-select -p &>/dev/null; then
  echo "Command Line Tools not found. Installing..."
  xcode-select --install
fi

# Check if running on Apple Silicon
if [[ "$(uname -m)" == "arm64" ]]; then
  if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
    echo "Rosetta 2 not found. Installing..."
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  fi
fi

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if command -v brew &>/dev/null; then
    echo "Homebrew installed successfully."
    echo
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "Homebrew installation failed."
    exit 1
  fi
fi

# Function to check and install a package
check_and_install() {
  package=$1
  formulaOrCask="${2:---formula}"

  if ! brew list "${formulaOrCask}" | grep -q "^$package\$"; then
    echo "$package is not installed. Installing..."
    brew install "$package"

    # Verify installation
    if brew list "${formulaOrCask}" | grep -q "^$package\$"; then
      echo "$package installed successfully."
    else
      echo "Failed to install $package."
    fi
  else
    echo "$package is already installed."
  fi
}

# Core packages
formulas=(
  "bash"
  "fzf"
  "neovim"
  "git"
  "ripgrep"
  "wget"
  "tmux"
  "tpm"
  "eza"
  "mise"
  "openssl@3"
  "readline"
  "libyaml"
  "gmp"
  "autoconf"
  "supabase/tap/supabase"

  # linters / formatters
  "fsouza/prettierd/prettierd"
  "biome"

  # mobile development
  "watchman"
)

# Apps I use
casks=(
  "vlc"
  "obsidian"
  "wezterm"
  "firefox@developer-edition"
  "google-chrome"
  "obs"
  "docker"
  "protonvpn"
  "android-studio"
)

# Loop over formulas and install them
echo "Installing formulas..."
for formula in "${formulas[@]}"; do
  check_and_install "$formula"
done

# Loop over casks and install them
echo "Installing casks..."
for cask in "${casks[@]}"; do
  check_and_install "$cask" "--cask"
done

source "$HOME/.zshrc"

mise use -g bun
mise use -g node
mise use -g java@temurin
