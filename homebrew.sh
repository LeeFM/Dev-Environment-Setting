#!/bin/bash

echo Install Mac App Store apps first.

# Either use mas-cli (https://github.com/argon/mas) or install manually; apps I need: Bear/Simplenote, Tyme, Polarr, Pixelmator, JPEGmini.
read -p "Press any key to continue… " -n1 -s
echo '\n'

# Check that Homebrew is installed and install if not
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# install xcode command tool
xcode-select --install
# check xcode command tool
xcode-select -p

# cocoapods install 
sudo gem install cocoapods -v 1.5.3

# install homebrew-cask
brew tap caskroom/cask
brew install brew-cask

# Update any existing homebrew recipes
brew doctor
brew update

# Upgrade any already installed formulae
brew upgrade --all

# Install my brew packages
brew install htop
brew install nmap
brew install wget
brew install mpv
brew install curl
brew install git
brew install htop-osx
brew install links
brew install svn
brew install tmux


# Install cask
brew tap phinze/homebrew-cask

# Install desired cask packages
brew cask install google-chrome
brew cask install go2shell iterm2 sublime-text
brew cask install sourcetree
brew cask install slack

# Remove brew cruft
brew cleanup

# Remove cask cruft
brew cask cleanup

# Link alfred to apps
#brew cask alfred link
