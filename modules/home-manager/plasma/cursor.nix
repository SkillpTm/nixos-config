{ config, pkgs, inputs, ... }:

let
	we10xos-cursors = pkgs.stdenv.mkDerivation {
		pname = "we10xos-cursors";
		version = "master";

		src = pkgs.fetchFromGitHub {
			hash = "sha256-dy6gA2jZa0pxwXDnc3ckxWd01k2UG0EWG8hoeU5T28Y=";
			owner = "yeyushengfan258";
			repo = "We10XOS-cursors";
			rev = "master";
		};

		installPhase = ''
			mkdir -p $out/share/icons/We10XOS-cursors
			cp -a dist/* $out/share/icons/We10XOS-cursors/
		'';
	};
in
{

	home = {
		packages = [ we10xos-cursors ];

		activation.copyWe10XOSCursors = config.lib.dag.entryAfter [ "writeBoundary" ] ''
			TARGET="$HOME/.local/share/icons/We10XOS-cursors"

			$DRY_RUN_CMD mkdir -p "$HOME/.local/share/icons"
			$DRY_RUN_CMD cp -Rf "${we10xos-cursors}/share/icons" "$TARGET"
			$DRY_RUN_CMD chmod -R u+w "$TARGET"
		'';
	};

	programs.plasma.workspace.cursor = {
		theme = "We10XOS-cursors";
		size = 24;
	};
}