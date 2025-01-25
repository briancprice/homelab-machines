# machine-configuration.nix
# Lenovo machine configurations settings
# Requires 
# - disko
{ config, ... }:
with config; {
  # The host name
  # Note, the host name is also used to calculate the machine name
  networking.hostName = "lenovo";  

  # ZFS settings...
  services.zfs.trim.enable = true;
  boot.kernelParams = ["zfs.zfs_arc_max=${builtins.toString(1024 * 1024 * 1024 * 2)}"];
  # The following line is required for vms
  boot.zfs.devNodes = "/dev/disk/by-path";

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

  # Impermenance settings

  fileSystems = {
    "/nix/persistent".neededForBoot = true;
    "/nix/persistent/sops".neededForBoot = true;
    "/nix/persistent/secure".neededForBoot = true;
    "/nix/persistent/games".neededForBoot = true;
  };

  environment.persistence."/nix/persistent" = {
    directories = [
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
    ];

    files = [
      # The machine id
      "/etc/machine-id"

      # The openssh keys
      "/etc/nixos/"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

}

