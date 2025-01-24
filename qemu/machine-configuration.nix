# machine-configuration.nix
# Lenovo machine configurations settings
# Requires 
# - disko
{ config, lib, ... }:
with config; with lib; {
  # The host name
  # Note, the host name is also used to calculate the machine name
  networking.hostName = mkDefault "qemu"; 

  # Add the guest agent
  services.qemuGuest.enable = true;

  # Boot settings...
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    # Use disko to mount the disks
    ./disko.nix

    # Hardware configuration for lenovo laptop
    ../qemu/hardware-configuration.nix
  ]; 
}

