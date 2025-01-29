# machine-configuration.nix
# Lenovo machine configurations settings
# Requires 
# - disko
{ config, lib, namespace, ... }:
with config; with lib; {

  # Add the guest agent
  services.qemuGuest.enable = true;

  imports = [
    # Use disko to mount the disks
    ./disko.nix

    # Hardware configuration for lenovo laptop
    ../qemu/hardware-configuration.nix
    ../common
    ({ config, namespace, ... }: {
      config.${namespace}.homelab.machines.qemu = {
      };
    })
  ]; 
}

