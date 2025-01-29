# common/default.nix
# Define the machine configuration options and perform default configuration
{ config, lib, pkgs, namespace, ... }:
with lib; {
  options.${namespace}.homelab.machines = mkOption {
    type = types.attrsOf ( types.submodule (
      { name, config, lib, ... }:
      let
        # cfg = config.${namespace}.homelab.machines.${name};
      in with lib; {
       options = {

          machineName = mkOption {
            type = type.str;
            default = name;
            description = "The display name for this machine configuration.";
          };

          hostIdSeed = mkOption {
            type = types.nullOr types.str;
            description = 
              ''
              The hostIdSeed will be used to calculate a hostId.
              The hostId is used by zfs so this should be unique.
              This should not be changed which is why hostName is
              no longer used.
              '';
            example = "Lenovo-laptop";
            default = null;
          };

          # For now, I only need one. 
          primaryNetworkInterface = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "enp0s25";
            description = "The primary network interface used to configure this network.";
          };

          virtualisation = mkOption {
            type = types.submodule (import ./subtypes/virtualisation.nix);
            description = "The virtualisation options for this machine.";
          };

          graphicsCards = mkOption { 
            type = types.attrsOf types.submodule ( import ./subtypes/graphics-card.nix );
            description = "Graphics cards information";
            default = {};
          };
        };

        config = {
          # Set the host-id here using the hostIdSeed
          # networking.hostId = mkIf (cfg.hostIdSeed != null) (builtins.substring 0 8 (builtins.hashString "sha256" cfg.hostIdSeed));
        };
    } ) );
    default = {};
  };

  config = {

    # Typical boot settings currently all machines support UEFI Boot
    boot.loader = {
      systemd-boot.enable = mkDefault true;
      efi.canTouchEfiVariables = mkDefault true;
    };
    
    # Always allow flakes and unfree software
    nix.settings.experimental-features = lib.mkDefault ["nix-command" "flakes"];
    nix.settings.cores = lib.mkDefault 0;
    nixpkgs.config.allowUnfree = true;
          
    # Minimal tools I want on all systems
    environment.systemPackages = with pkgs; [ 
      neofetch
      vim git wget 
      usbutils pciutils nfs-utils 
      lm_sensors smartmontools
    ];
  };
}
