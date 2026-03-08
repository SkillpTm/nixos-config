set PURPLE "\033[1;35m"
set RESET "\033[0m"

cd $HOME/nix-config
git add .
git --no-pager diff --staged --color=always

set OLD_GEN (nixos-rebuild list-generations | awk '$NF=="True" {print $1}')
sudo nixos-rebuild switch --flake .#$hostname --show-trace --no-reexec
set NEW_GEN (nixos-rebuild list-generations | awk '$NF=="True" {print $1}' )

if test $NEW_GEN -eq $OLD_GEN
	git reset > /dev/null
    echo -e "$PURPLE""No functional changes.""$RESET"
    exit 0
end

set HASH (basename (readlink /run/current-system) | cut -d- -f1)
git commit -m "Switch: Generation $NEW_GEN ($HASH)"

nvd diff /nix/var/nix/profiles/system-$OLD_GEN-link /nix/var/nix/profiles/system
echo -e "$PURPLE""Switch: Generation $NEW_GEN ($HASH)""$RESET"