#!/bin/bash

# Get the operating system name
OS=$(uname)

if [ "$OS" != 'Darwin' ]; then
	echo 'This script is written for macOS'
	exit 1
fi

if ! command -v brew &> /dev/null; then
	echo "Homebrew is not installed. Installing now..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	
	if command -v brew &> /dev/null; then
		echo "Homebrew installed successfully."
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
