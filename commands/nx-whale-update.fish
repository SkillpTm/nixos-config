set PURPLE "\033[1;35m"
set RESET "\033[0m"

set HASH_FILE "$HOME/nixos-config/modules/custom/whale/naver-whale-hash.txt"
set OLD_HASH (cat "$HASH_FILE")
set NEW_HASH (nix-prefetch-url https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb | tail -n 1)

if test "$NEW_HASH" = "$OLD_HASH"
	echo -e "$PURPLE""Naver Whale is already up to date!""$RESET"
	exit 0
end

echo "$PURPLE""Update found! $OLD_HASH --> $NEW_HASH""$RESET"
echo -n "$NEW_HASH" > "$HASH_FILE"

nx-rebuild