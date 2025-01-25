{config, lib, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.homelab-machines.dell-5810;

  isolate-ids-list = with cfg.graphics.cards; [
    nvidia-1060.graphics.deviceId
    nvidia-1060.sound.deviceId
  ];

  isolate-ids = (lib.concatStringsSep "," isolate-ids-list); 
in 
{ 
  boot.kernelParams = [ 
    "intel_iommu=on" 
    "vfio-pci.ids=${isolate-ids}" 
  ]; 
}
