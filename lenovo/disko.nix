 # Disko configuration for my lenovo laptop
{
  disko.devices = 
  {
    disk.main = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {

          # The Boot Partition
          ESP = {
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

          # The Swap Partition
          swap = {
            size = "32G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          # The Data Partition 
          zdevone = {
            size = "100%";
            content = 
            {
              type = "zfs";
              pool = "premium";
            };
          };
       };
      };
    
    };

    # Ephemeral root partition
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [ "noatime" "norelatime" "size=25%" "mode=755" ];
    };

    # Initialize zfs
    zpool.premium = {
      type = "zpool";
      mode = "";

      # options are lowercase -o settings
      options = {
        ashift = "12";
        autotrim = "on";
      };

      # rootFsOptions are uppercase -O settings
      rootFsOptions = {
        acltype = "posixacl";
        atime = "off";
        relatime = "off";
        compression = "lz4";
        dnodesize = "auto";
        mountpoint = "none";
        recordsize = "128K";
        xattr = "sa";
        "com.sun:auto-snapshot" = "false";
      };

      # Initialize zfs datases
      datasets = {

        # Reserve space at the beginning of the dataset
        reserved = {
          type = "zfs_fs";
          options.refreservation = "10G";
          options.mountpoint = "none";
        };

        # The NixOS persistant settings will be here
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options.mountpoint = "legacy";
        };

        # The persistent store
        persistence = {
          type = "zfs_fs";
          mountpoint = "/nix/persistent";
          options.mountpoint = "legacy";
        };

        # Location for sops files
        sops = {
          type = "zfs_fs";
          mountpoint = "/nix/persistent/sops";
          options.mountpoint = "legacy";
        };

        # TODO: Make this an encrypted dataset
        secure = {
          type = "zfs_fs";
          mountpoint = "/nix/persistent/secure";
          options.mountpoint = "legacy";
        };

        # Location for games
        games = {
          type = "zfs_fs";
          mountpoint = "/nix/persistent/games";
          options.mountpoint = "legacy";
        };
      };

    };
  };
}
