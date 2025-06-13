{ lib, ... }:

let
  mainDevice = "/dev/sda";
  storageDevice = "";
  swapSize = "16G";
  defaultMountOptions = [ "compress-force=zstd" "noatime" "nodiratime" ];
in {
  disko.devices = {
    disk = {

      main = {
        device = mainDevice;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {

            ESP = {
              priority = 1;
              name = "ESP";
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = swapSize;
              content = {
                type = "swap";
                discardPolicy = "once";
                resumeDevice = true;
              };
            };

            root = {
              size = "100%";
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
                  "@snapshots" = lib.mkIf (storageDevice == "") {
                    mountpoint = "/snapshots";
                    mountOptions = defaultMountOptions;
                  };
                };
              };
            };

          };
        };
      };

      storage = lib.mkIf (storageDevice != "") {
        device = storageDevice;
        type = "disk";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@snapshots" = {
              mountpoint = "/snapshots";
              mountOptions = defaultMountOptions;
            };
            "@storage" = {
              mountpoint = "/storage";
              mountOptions = defaultMountOptions ++ [ "umask=0000" ];
            };
          };
        };
      };
      
    };
  };
}