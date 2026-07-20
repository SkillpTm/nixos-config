{ config, lib, pkgs, ... }:

{
	home.activation.setupDolphinPlaces = lib.hm.dag.entryAfter ["writeBoundary"] ''
		TARGET="$HOME/.local/share/user-places.xbel"

		mkdir -p "$HOME/.local/share"
		cp -f "${./user-places.xbel}" "$TARGET"
		chmod u+w "$TARGET"
	'';
}