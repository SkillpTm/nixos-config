set GREEN "\033[1;32m"
set RED "\033[1;31m"
set RESET "\033[0m"

argparse --max-args 0 -x b,u,s,t 'b/boot' 's/switch' 't/test' 'u/update' -- $argv
or exit 1

if not set -q _flag_b; and not set -q _flag_u; and not set -q _flag_t
    set _flag_s 1
end

if set -q _flag_b
	set type "Boot"
else if set -q _flag_u
	set type "Update"
else if set -q _flag_s
	set type "Switch"
end

cd $HOME/nixos-config || exit 1
set -l stashed false

if not set -q _flag_u
	git add .
else
	git reset > /dev/null
	nix flake update
	git add flake.lock

	if not git diff --quiet
		set stashed true
		git stash --keep-index
	end
end

git --no-pager diff --staged --color=always

set OLD_GEN (nixos-rebuild list-generations | awk '$NF=="True" {print $1}')

if set -q _flag_b
	sudo nixos-rebuild boot --flake .#$hostname --show-trace --no-reexec
else if set -q _flag_t
	sudo nixos-rebuild test --flake .#$hostname --show-trace --no-reexec
else
	sudo nixos-rebuild switch --flake .#$hostname --show-trace --no-reexec
end

set NEW_GEN (nixos-rebuild list-generations | awk '$NF=="True" {print $1}')

if $stashed
	git stash pop
end

if test "$NEW_GEN" = "$OLD_GEN"
	git reset > /dev/null

	if not set -q _flag_t
		echo -e "$GREEN""No generational changes""$RESET"
	else
		echo -e "$GREEN""Test rebuild applied""$RESET"
	end

	if set -q _flag_u
		git restore flake.lock > /dev/null
	end

	exit 0
end

# Major version change may update flake.lock somewhere during building, so we need to re-add changes
git add .

set HASH (basename (readlink -f /nix/var/nix/profiles/system) | cut -d- -f1)
git commit -m "$type: $hostname Generation $NEW_GEN ($HASH)"

nvd diff /nix/var/nix/profiles/system-$OLD_GEN-link /nix/var/nix/profiles/system
echo -e "$GREEN""$type: Generation $NEW_GEN ($HASH)""$RESET"