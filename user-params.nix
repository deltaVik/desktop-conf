{
  # Please read and edit this config carefully before changing this option!
  # Set "confirmation = true;" if you are confident that the configuration is correct
  confirmation = false;

  # Disk partitioning options.
  # WARNING: all selected disks will be wiped!
  disks = {

    # Main disk device for ESP, root, /home and /nix (also /snapshots, if storageDevice is empty)
    mainDevice = "/dev/sda"; # e.g. "/dev/sda"

    # Secondary disk device for /storage and /snapshots.
    # Optional - leave blank if you don't have one.
    storageDevice = ""; # e.g. "/dev/sdb"

    # Swap size. Recommended size (for hibernation): size of the RAM + 1GB.
    # Optional - leave blank if you don't need swap.
    swapSize = "16G"; # e.g. "16G"

    # Default mount options for all devices.
    defaultMountOptions = [ "compress-force=zstd" "noatime" "nodiratime" ];
  };
}