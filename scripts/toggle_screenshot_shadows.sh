#!/bin/bash

toggle_screenshot_shadow() {
  if [[ "$1" == 'true' || "$1" == 'false' ]]; then
    echo "Disabling screenshot dropshadows to $1"
    defaults write com.apple.screencapture disable-shadow -bool "$1"
    killall SystemUIServer
  else
    echo "Invalid arg. Use 'true' or 'false'"
    return 1
  fi
}

toggle_screenshot_shadow "$1"
