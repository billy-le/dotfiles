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
else
    echo "Command Line Tools are already installed."
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
	echo "Homebrew is not installed. Installing now..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	
	if command -v brew &> /dev/null; then
		echo "Homebrew installed successfully."
		echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
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
	"fzf"
	"neovim"
	"git"
	"ripgrep"
	"wget"
)

# Apps I use
casks=(
	"vlc"
	"obsidian"
	"wezterm"
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

# Install Node Version Manager
export NVM_DIR="$HOME/.nvm"
(
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" &&
  cd "$NVM_DIR" &&
  git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))"
)

# Add NVM to .zshrc and load NVM
NVM_LINES='
# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
'

if ! grep -q 'NVM configuration' "$HOME/.zshrc"; then
    echo "$NVM_LINES" >> "$HOME/.zshrc"
    echo "NVM lines added to .zshrc."
    source "$HOME/.zshrc"
else
    echo "NVM lines already exist in .zshrc."
fi

## Install lastest Node version
nvm install node

## Install BUN
curl -fsSL https://bun.sh/install | bash

source "$HOME/.zshrc"
