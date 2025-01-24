# Default configuration for my Dell 5810
{ config, lib, namespace, ... }:
let
  cfg = config.${namespace}.homelab-machines.dell-5810;

  isolate-ids-list = with cfg.graphics.nvidia.cards; [
    nvidia-1060.graphics.deviceId
    nvidia-1060.sound.deviceId
  ];

  isolate-ids = (lib.concatStringsSep "," isolate-ids-list);
in
{
  imports = [
    ({ ... }: {  nixpkgs.config.nvidia.acceptLicense = true; })
    ./hardware-configuration-with-filesystems.nix
    ./graphics-cards.nix
    ../common/nvidia.nix
  ];


  config = {

    # Typical boot settings
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };


    # For clarity configure all virtualization support here.
    # Credit: [astrid.tech](https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/)
    # Credit: [NixOS Wiki](https://nixos.wiki/wiki/Nvidia)

    # This configuration uses the k4000 for the host and the
    #   1060 is reserved for guests
    
    # Enable IOMMU support
    boot = {
      kernelParams = [
        "intel_iommu=on"
        "vfio-pci.ids=${isolate-ids}"
      ];

      initrd.kernelModules = [
        "vfio_pci" "vfio" "vfio_iommu_type1"
        "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"
      ];

      # Blacklist the drivers that aren't being used...
      blacklistedKernelModules = [ "nouveau" ];

    };


    # These settings are for using NVIDIA on the host not vfio
    hardware = {
      graphics.enable = true;

      nvidia = {
        # Most recent supported driver for K4000
        

        package = config.boot.kernelPackages.nvidiaPackages.legacy_390;

        modesetting.enable = true;
        # TODO: see if power management will work
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false; # Disable the open source kernel module
        nvidiaSettings = true;
      }; 
    };
    
    services.xserver.videoDrivers = ["nvidia"];
  };
}