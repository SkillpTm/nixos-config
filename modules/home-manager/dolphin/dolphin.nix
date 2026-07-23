{ lib, ... }:

{
	home.activation.setupDolphinPlaces = lib.hm.dag.entryAfter ["writeBoundary"] ''
		TARGET="$HOME/.local/share/user-places.xbel"

		$DRY_RUN_CMD mkdir -p "$HOME/.local/share"
		$DRY_RUN_CMD cp -f "${./user-places.xbel}" "$TARGET"
		$DRY_RUN_CMD chmod u+w "$TARGET"
	'';
}