# Default configuration for my Dell 5810
{ config, lib, namespace, ... }:
let
  cfg = config.${namespace}.homelab-machines.dell-5810;
in
with lib; {
  imports = [
    ../common/nvidia.nix
  ];

  # Define the graphics cards...
  config.${namespace}.homelab-machines.dell-5810.graphics.nvidia.cards = {
    
    nvidia-1060 = {
      graphics = {
        deviceId = "10de:1c03";
        pcieId = "04:00.0";
        iommu-group = 47;
        reserve-for-vfio-pci = false;
        description = "NVIDIA GeForce GTX 1060 6GB";
      };
      sound = {
        deviceId = "10de:10f1";
        pcieId = "04:00.1";
        iommu-group = 47;
        reserve-for-vfio-pci = false;
        description = "NVIDIA (GTX 1060) GP106 High Definition Audio Controller";
      };
    };

    nvidia-k4000 = {
      graphics = {
        deviceId = "10de:11fa";
        pcieId = "03:00.0";
        iommu-group = 46;
        reserve-for-vfio-pci = false;
        description = "NVIDIA Quadro K4000";
      };
      sound = {
        deviceId = "10de:0e0b";
        pcieId = "03:00.1";
        iommu-group = 46;
        reserve-for-vfio-pci = false;
        description = "NVIDIA (K4000) GP106 High Definition Audio Controller";
      };
      notes = "The NVIDIA K4000 has entered legacy mode and is only supported by the legacy_390 card and earlier.";
    };
  };
}