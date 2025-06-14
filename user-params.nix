{
  # Main disk device for EPS, root, /home and /nix (also /snapshots, if storageDevice is empty)
  mainDevice = "/dev/sda";

  # Secondary disk device for /storage and /snapshots.
  # Optional - leave blank if you don't have one.
  storageDevice = "";

  # Swap size. Recommended size (for hibernation): size of the RAM + 1GB.
  # Optional - leave blank if you don't need swap.
  swapSize = "16G";

  # Default mount options for all devices.
  defaultMountOptions = [ "compress-force=zstd" "noatime" "nodiratime" ];
}