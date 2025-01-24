# Settings applicable to all configurations
{config, pkgs, lib, namespace, ...}:
{
  imports = [];

  # Enable flakes
  nix.settings.experimental-features = lib.mkDefault ["nix-command" "flakes"];
  nix.settings.cores = lib.mkDefault 0;

  nixpkgs.config.allowUnfree = true;
        

  # Set a hostId, this is needed by zfs
  # WARNING, if you change the hostName after onboarding the PC, the hostId will also change!
  networking.hostId = (builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName));

  # Provide default packages
  environment.systemPackages = with pkgs; [ 
    neofetch
    vim git wget 
    usbutils pciutils nfs-utils 
    lm_sensors smartmontools
  ];
}
