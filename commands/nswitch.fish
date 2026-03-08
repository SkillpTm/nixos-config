cd $HOME/nix-config
git add .
git diff --color=always
sudo nixos-rebuild switch --flake .#$hostname --show-trace --no-reexec
set GEN (nixos-rebuild list-generations | awk '$NF=="True" {print $1}' )
set HASH (basename (readlink /run/current-system) | cut -d- -f1)
git commit -m "Switch: Generation $GEN ($HASH)"
set PREV_GEN (math $GEN - 1)
nvd diff /nix/var/nix/profiles/system-$PREV_GEN-link /nix/var/nix/profiles/system

echo "Switch: Generation $GEN ($HASH)"