{ name, config, lib, ... }:
with lib; {
  options = {
    graphics = mkOption {
      type = types.submodule (import ./iommu-device.nix);
      description = "The graphics portion of the graphics card.";
    };
    sound = mkOption {
      type = types.submodule (import ./iommu-device.nix);
      description = "The sound portion of the graphics card.";
    };
    notes = mkOption {
      type = types.str;
      description = "Any notes about the graphics card for reference.";
    };
  };
}
