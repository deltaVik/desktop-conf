{ lib, ... }:

let
  params = import "./user-params.nix";
in {
  disko.devices = {
    disk = {

      main = {
        device = params.mainDevice;
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
              size = params.swapSize;
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
                    mountOptions = params.defaultMountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = params.defaultMountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = params.defaultMountOptions;
                  };
                  "@snapshots" = lib.mkIf (params.storageDevice == "") {
                    mountpoint = "/snapshots";
                    mountOptions = params.defaultMountOptions;
                  };
                };
              };
            };

          };
        };
      };

      storage = lib.mkIf (params.storageDevice != "") {
        device = params.storageDevice;
        type = "disk";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@snapshots" = {
              mountpoint = "/snapshots";
              mountOptions = params.defaultMountOptions;
            };
            "@storage" = {
              mountpoint = "/storage";
              mountOptions = params.defaultMountOptions ++ [ "umask=0000" ];
            };
          };
        };
      };
      
    };
  };
}