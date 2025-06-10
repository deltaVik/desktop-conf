let
  defaultMountOptions = [ "compress-force=zstd" "noatime" ];
  swapSize = "16G";
in {
  disko.devices = {
    disk = {

      primary = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              priority = 1;
              name = "ESP";
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              end = "-" + swapSize;
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = defaultMountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = defaultMountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = defaultMountOptions;
                  };
                };
              };
            };

            swap = {
              size = swapSize;
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };

          };
        };
      };
    };
  };
}