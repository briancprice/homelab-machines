# Default configuration for my Dell 5810
# Credit: [astrid.tech](https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/)
# Credit: [NixOS Wiki](https://nixos.wiki/wiki/Nvidia)
{ config, lib, namespace, ... }:
let 
  cfg = config.${namespace}.homelab.machines.dell-5810;
  graphicsCfg = config.${namespace}.homelab.machines-custom.dell-5810.graphics;
in
with lib; {
  imports = [
    ../common
    ./hardware-configuration-with-filesystems.nix
    ./graphics.nix
    ({ config, namespace, ...}: 
    let
      driver = graphicsCfg.hostNvidiaGraphicsDriver;
      cardEnabled = (!(graphicsCfg.isolate1060 && graphicsCfg.isolateK4000));
      proprietaryNvidiaKernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
      nouveauNvidiaKernelModules = ["nouveau"];
    in
    {
       config = mkIf (assert asserts.assertMsg (!((!cardEnabled) && driver != "disabled"))
      "Both graphics cards are reserved so hostNvidiaGraphicsDriver should be disabled."; true)
      {
        # Add the drivers needed by the host
        boot.initrd.kernelModules = optionals ( driver == "proprietary" )  
          proprietaryNvidiaKernelModules
        ++ optionals ( driver == "nouveau" ) 
          nouveauNvidiaKernelModules;

        # Blacklist the drivers not being used by the host
        boot.blacklistedKernelModules = 
        optionals ( elem driver ["proprietary" "disabled" ] )
          nouveauNvidiaKernelModules
        ++ optionals ( elem driver ["nouveau" "disabled" ] )
          proprietaryNvidiaKernelModules;

        # Enable graphics if at least one card is enabled
        hardware.graphics.enable = cardEnabled;

        hardware.nvidia = mkIf cardEnabled {

          # If the K4000 isn't isolated we have to use the old driver
          package = mkIf (driver == "proprietary") (if ( !graphicsCfg.isolateK4000) then 
            config.boot.kernelPackages.nvidiaPackages.legacy_390 else
            config.boot.kernelPackages.nvidiaPackages.production);

          # PowerSettings
          # TODO: See how well power management works
          powerManagement.enable = false;
          powerManagement.finegrained = false;

          # We can't support the open driver
          open = false;

          nvidiaSettings = (!graphicsCfg.headlessHost);
        };

        nixpkgs.config.nvidia.acceptLicense = if driver == "proprietary" then true else false;

        services.xserver.videoDrivers = mkIf (elem driver [ "proprietary" "nouveau" ]) 
          (if (driver == "nouveau" ) then ["nouveau"] 
            else if (driver == "proprietary") then ["nvidia"] else []);
      };
    })
  ]; 

  config.${namespace}.homelab.machines.dell-5810 = {
    hostIdSeed = "dell-5810";
    primaryNetworkInterface = "enp0s25";
    virtualisation = {
      enable = true;
      cpu = "intel";
      passthroughEnable = true;
    };

    # graphicsCards = (import ./graphics-cards.nix);

    virtualisation = { 
    vfioIsolatedPciIds = optional graphicsCfg.isolate1060 [ 
      cfg.graphicsCards.nvidiaa-1060.graphics.deviceId 
      cfg.graphicsCards.nvidia-1060.sound.deviceId 
      ] ++ optional graphicsCfg.isolateK4000 [
        cfg.graphicsCards.nvidia-k4000.graphics.deviceId
        cfg.graphicsCards.nvidia-k4000.sound.deviceId
      ];
    };
  };
}