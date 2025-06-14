{ lib, ... }:

let
  params = import "./user-params.nix";
in {
  disko.devices = {
    disk = {

      main = {
        device = params.disks.mainDevice;
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

            swap = lib.mkIf (params.disks.swapSize != ""){
              size = params.disks.swapSize;
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
                    mountOptions = params.disks.defaultMountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = params.disks.defaultMountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = params.disks.defaultMountOptions;
                  };
                  "@snapshots" = lib.mkIf (params.disks.storageDevice == "") {
                    mountpoint = "/snapshots";
                    mountOptions = params.disks.defaultMountOptions;
                  };
                };
              };
            };

          };
        };
      };

      storage = lib.mkIf (params.disks.storageDevice != "") {
        device = params.disks.storageDevice;
        type = "disk";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@snapshots" = {
              mountpoint = "/snapshots";
              mountOptions = params.disks.defaultMountOptions;
            };
            "@storage" = {
              mountpoint = "/storage";
              mountOptions = params.disks.defaultMountOptions ++ [ "umask=0000" ];
            };
          };
        };
      };
      
    };
  };
}