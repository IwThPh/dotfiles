#!/bin/sh

# Script to synchronize system state
# with configuration files for nixos system
# and home-manager

SCRIPTS_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Rebuild system
sudo nixos-rebuild switch --flake $SCRIPTS_DIR/../.#system;
