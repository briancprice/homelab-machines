# The NVIDIA Geforce 1060 6GB graphics card config
{ config, pkgs, lib, namespace, ... }:
let 
  cfg = config.${namespace}.homelab-machines.dell-5810.graphics.nvidia;

  graphics-card = {config, lib, ...}: with lib; {
    options = {
      graphics = lib.mkOption {
        type = lib.types.submodule (import ../common/iommu-device.nix);
        description = "The graphics portion of the graphics card.";
      };
      sound = lib.mkOption {
        type = lib.types.submodule (import ../common/iommu-device.nix);
        description = "The sound portion of the graphics card.";
      };
      notes = lib.mkOption {
        type = lib.types.string;
        description = "Any notes about the graphics card for reference.";
      };
    };
  };

in with lib; {

  options.${namespace}.homelab-machines.dell-5810.graphics.nvidia = {
    enable = mkEnableOption { 
      default = true; 
      description = ''
        The enable option enables the cards settings, if enable is set to false, the card will be handled using the 
        default OS settings, typically it will be assigned to the nouveau driver.
        '';
    };

    cards = lib.mkOption { 
      type = lib.types.attrsOf (lib.types.submodule (graphics-card) );
      default = {};
      description = "NVIDIA Graphics card information";
    };

    driver = mkOption {
      type = types.enum [ "none" "nouveau" "proprietary" "nvidia-open" ];
      default = "nouveau";
      description = ''
      The driver to use for the NVIDIA  graphics card
      * **none**          Disable all nvidia graphics drivers
      * **nouveau:**      (default), The open-source Nouveau driver.  Not to be confused with the NVIDIA open-source driver.
      * **proprietary:**  Use a proprietary nvidia driver, Note: config.hardware.nvidia should be set to an appropriate driver package
      * **nvidia-open**   Use the NVIDIA open-source driver
      '';
    };
  };

  # k4000 configuration options
  config = mkIf cfg.enable {

    hardware.nvidia = {

      # Set the legacy driver if configured
      # package = mkIf (cfg.driver == "legacy_390") boot.kernelPackages.nvidiaPackages.legacy_390;
    
      # The NVIDIA open-source driver doesn't support the k4000
      # Disable it here and if another card needs it, override elsewhere 
      # open = mkDefault false;
      
    };

    warnings = if config.hardware.nvidia.open then [
      ''You have enabled the NVIDIA open source driver.
        This driver does not support the k4000!
      ''] else [];

     # Blacklist the nouveau driver
     # boot.blacklistedKernelModules = mkIf (cfg.driver == "legacy_390") [ "nouveau" ];
  };
}
