# Configuration information for a graphics card
# Note: This is a submodule

{ name, config, lib, ... }:
with lib; {

  options = {

    name = mkOption {
      type = type.str;
      default = name;
      description = "The display name for this graphics card";
    };

    description = mkOption {
      type = type.str;
      default = "";
      description = "The description for this device.";
    };

    deviceId = mkOption {
      type = types.str;
      default = _deviceId;
      description = "The device ID in the format xxxx:xxxx";
    };

    pcieId = mkOption {
      type = types.str;
      default = _graphics-pcieId;
      description = "The PCIE ID of the card, in the format 03:00.0";
    };

    iommu-group = mkOption {
      type = types.ints.unsigned;
      default = _iommu-group;
      description = "The IOMMU group of the card.";
    };

    reserve-for-vfio-pci = mkOption {
      type = types.bool;
      default = false;
      description = "Reserve the card for use with the vfio-pci driver, this will make the card invisible to the host os.";
    };

  };
}