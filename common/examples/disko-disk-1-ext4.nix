{ device, ... }:
let
  espPartition = (import ./disko-partition-ESP.nix { device = device; });
in 
{
  device = device;
  type = "disk";
  content = {
    type = "gpt";
      partitions = {
        ESP = espPartition;
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "noatime" "norelatime" ];
          };
        };
      };
    };
}  
