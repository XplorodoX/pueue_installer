#!/bin/bash

# Function to download and install a package
function download_and_install {
  # Define package name as the first argument passed to the function
  package=$1

  # Check operating system and set variable "os"
  if [ "$(uname)" == "Darwin" ]; then
    os="darwin"
    echo $os
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    os="linux"
    echo $os
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    os="windows"
    echo $os
  else
    # Print error message if operating system is unsupported
    echo "Unsupported operating system"
    exit 1
  fi

  # Check architecture and set variable "arch"
  if [ "$(uname -m)" == "x86_64" ]; then
    arch="x86_64"
    echo $arch
  elif [ "$(uname -m)" == "aarch64" ]; then
    arch="aarch64"
    echo $arch
  elif [ "$(uname -m)" == "armv7l" ]; then
    arch="armv7"
    echo $arch
  else
    # Print error message if architecture is unsupported
    echo -e "\033[31mUnsupported architecture\033[0m"
    exit 1
  fi

  # Define URL for downloading the package
  url="https://github.com/Nukesor/pueue/releases/download/v3.0.1/${package}-${os}-${arch}"

  # Download the package using curl
  curl -s -L -O $url

  # Check if the download was successful
  if [ $? -eq 0 ]; then
    # Print success message
    echo -e "\033[33mDownload successful\033[0m"
  else
    # Print error message if the download failed
    echo -e "\033[31mDownload failed\033[0m"
  fi

  # Give execute permission to the downloaded file
  chmod 777 ${package}-${os}-${arch}

  # Move the downloaded file to the current directory and rename it
  mv ${package}-${os}-${arch} $package

  # Move the package to the /usr/bin directory
  sudo mv $package /usr/bin/
  
}

# Download and install pueue
download_and_install pueue
# Download and install pueued
download_and_install pueued

# Download the pueued.service file
curl -s -L -O https://github.com/Nukesor/pueue/raw/main/utils/pueued.service

# Give execute permission to the file
chmod 777 pueued.service

# Move the file to the /etc/systemd/user/ directory and rename it to pueued.service
sudo mv pueued.service /etc/systemd/user/pueued.service

# Reload the daemon
systemctl --user daemon-reload 
# Enable the pueued service
systemctl --user enable pueued.service 
# Start the pueued service
systemctl --user start pueued.service 

echo -e "\033[31mFinish\033[0m"