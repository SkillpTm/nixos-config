{ config, pkgs, inputs, ... }:

let
	we10xos-cursors = pkgs.stdenv.mkDerivation {
		pname = "we10xos-cursors";
		version = "master";

		src = pkgs.fetchFromGitHub {
			hash = pkgs.lib.fakeHash;
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
	};

	programs.plasma.workspace.cursor = {
		theme = "We10XOS-cursors";
		size = 24;
	};
}