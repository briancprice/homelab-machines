 # Disko configuration for a qemu vm laptop
{
  disko.devices = 
  {
    disk.main = 
    {
      device = "/dev/vda";
      type = "disk";
      content = 
      {
        type = "gpt";
        partitions = {
          ESP = 
          {
            size = "500M";
            type = "EF00";
            content = 
            {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          root = 
          {
            size = "100%";
            content = 
            {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "noatime" "norelatime" ];
            };
          };
        };
      };
    };
  };
}
