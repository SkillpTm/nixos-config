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
			cp -va dist/* $out/share/icons/We10XOS-cursors/
		'';
	};
in
{
	home = {
		packages = [ we10xos-cursors ];

		pointerCursor = {
			name = "We10XOS-cursors";
			package = we10xos-cursors;
			size = 24;
			gtk.enable = true;
			x11.enable = true;
		};

		sessionVariables = {
			XCURSOR_THEME = "We10XOS-cursors";
			XCURSOR_SIZE = "24";
		};
	};

	programs.plasma.workspace.cursor = {
		theme = "We10XOS-cursors";
		size = 24;
	};
}