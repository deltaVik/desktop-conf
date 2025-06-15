echo "WARNING: This action will destroy all data on your disks! Please check disko-config.nix before use."
read -p "This action is irreversible. Are you sure you want to start partitioning? (yes/no): " user_answer
if [[ "$user_answer" == "yes" ]]; then
    echo "Starting partitioning..."
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix
else
    echo "Partitioning aborted."
fi