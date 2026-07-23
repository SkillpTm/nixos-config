rm -rf ~/.local/share/Trash/files ~/.local/share/Trash/info ~/.local/share/Trash/expunged
mkdir -p ~/.local/share/Trash/{files,info,expunged}

sudo journalctl --vacuum-time=30d
sudo nix-collect-garbage --delete-older-than 30d
sudo nix store optimise
sudo /run/current-system/bin/switch-to-configuration boot