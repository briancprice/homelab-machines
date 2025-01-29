
# Enable/disable virtualisation support
# Note, we use the English spelling virtualisation for NixPkg option consistency.
{name, config, lib, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.homelab.machines.${name}.virtualisation;
in 
with lib; { 

  imports = [
    ({ ... }: with lib; {
      config = mkIf ( 
        assert assertMsg (!(cfg.enable && cfg.cpu == "none")) 
          "Virtualisation has been enabled but the cpu is set to none." 
          (cfg.enable) ) 
      {
        # Set the kernel parameters for virtualisation
        boot.kernelParams = optional ( cfg.cpu == "intel" ) [ "intel_iommu=on" ]
        ++ optional ( cfg.cpu == "amd" ) [ "amd_iommu=on" ]
        ++ optional ( cfg.passthroughEnable ) [ "iommu=pt" ]
        ++ optional ( !isEmpty cfg.vfioIsolatedPciIds ) 
          [ "vfio-pci.ids=${lib.concatStringsSep "," cfg.vfioIsolatedPciIds}" ];

        # Set the kernel modules
        boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1"  "kvm" ]
        ++ optional ( cfg.cpu == "intel" ) [ "kvm_intel" ]
        ++ optional ( cfg.cpu == "amd" ) [ "kvm_amd" ];
      };
    })
  ];

  options = {

    enable = mkEnableOption {
      default = false;
      description = "Enable virtualisation on this PC.";

    };

    cpu = mkOption {
      type = types.enum [ "none" "amd" "intel" ];
      default = "none";
      description = 
        ''
        **none**:   Virtualisation is not supported.
        **amd**:    AMD Virtualisation
        **intel**:  Intel Virtualisation
        '';
    };

    passthroughEnable = mkEnableOption {
      default = true;
      description = "Add iommu=pt to kernel parameters."
    };

    vfioIsolatedPciIds = mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "The list of PCI ids that should be isolated by assigning them to vfio";
      example = ''[ "10de:1c03" "10de:10f1" ]'';
    };

  };
}
