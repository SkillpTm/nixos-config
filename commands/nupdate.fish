cd $HOME/nix-config
nix flake update
git reset && git add flake.lock
sudo nixos-rebuild switch --flake .#$hostname --show-trace --no-reexec
set GEN (nixos-rebuild list-generations | awk '$NF=="True" {print $1}' )
set HASH (basename (readlink /run/current-system) | cut -d- -f1)
git commit -m "Update: Generation $GEN ($HASH)"
set PREV_GEN (math $GEN - 1)
nvd diff /nix/var/nix/profiles/system-$PREV_GEN-link /nix/var/nix/profiles/system

echo "Update: Generation $GEN ($HASH)"