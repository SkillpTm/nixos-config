set PURPLE "\033[1;35m"
set RESET "\033[0m"

set HASH_FILE "$HOME/nix-config/modules/custom/whale/naver-whale-hash.txt"

set NEW_HASH (nix-prefetch-url --force "https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb" 2>/dev/null)
set OLD_HASH (cat "$HASH_FILE")

if test "$NEW_HASH" = "$OLD_HASH"
	echo -e "$PURPLE""Naver Whale is already up to date!""$RESET"
	exit 0
end

echo "Update found! $OLD_HASH --> $NEW_HASH"
echo -n "$NEW_HASH" > "$HASH_FILE"

nswitch