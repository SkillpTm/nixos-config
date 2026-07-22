rm -rf ~/.local/share/Trash/files/*
rm -rf ~/.local/share/Trash/info/*
rm -rf ~/.local/share/Trash/expunged/*

sudo journalctl --vacuum-time=30d
sudo nix-collect-garbage --delete-older-than 30d
sudo nix store optimise
sudo /run/current-system/bin/switch-to-configuration boot