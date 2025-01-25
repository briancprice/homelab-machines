# Settings applicable to all configurations
{config, pkgs, lib, namespace, ...}:
with lib; {
  imports = [
    ./networking.nix
  ];

  # Typical boot settings
  boot.loader = {
    systemd-boot.enable = mkDefault true;
    efi.canTouchEfiVariables = mkDefault true;
  };
   
  # Enable flakes
  nix.settings.experimental-features = lib.mkDefault ["nix-command" "flakes"];
  nix.settings.cores = lib.mkDefault 0;

  nixpkgs.config.allowUnfree = true;
        
  # Provide default packages
  environment.systemPackages = with pkgs; [ 
    neofetch
    vim git wget 
    usbutils pciutils nfs-utils 
    lm_sensors smartmontools
  ];
}
