{ config, lib, namespace, ... }:
with lib; {

  options.${namespace}.homelab.machines-custom.dell-5810.graphics  =
  {
    isolate1060 = mkOption {
      type = types.bool;
      default = false;
      description = "If true, the card will be reserved for vfio-pci.";
    };

    isolateK4000 = mkOption {
      type = types.bool;
      default = false;
      description = "If true the card will be reserved for vfio-pci.";
    };

    hostNvidiaGraphicsDriver = mkOption {
      type = types.enum [ "ignore" "disabled" "nouveau" "proprietary" ];
      default = "ignore";
      description = 
        ''
        **ignore**:       No driver-related settings will be applied.
        **disabled**:     All NVIDIA drivers will be disabled on the host.
        **nouveau**:      The open-source (not NVIDIA's) driver will be used
        **proprietary**:  The proprietary NVIDIA driver will be based on which cards are enabled.     
        
        NOTE: 
        - No cards in this system support the NVIDIA open-source driver.
        '';
    };

    headlessHost = mkOption {
      type = types.bool;
      default = false;
      description = "If headlessHost is false, the Nvidia settings app will be added and xserver graphics will be enabled.";
    };

  };
}