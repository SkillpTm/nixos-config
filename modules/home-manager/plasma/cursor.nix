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
		packages = [
			we10xos-cursors

			(pkgs.discord-canary.overrideAttrs (old: {
				commandLineArgs = (old.commandLineArgs or "") + " --enable-features=UseOzonePlatform --ozone-platform=wayland";
			}))
		];

		activation.copyWe10XOSCursors = config.lib.dag.entryAfter [ "writeBoundary" ] ''
			THEME_NAME="We10XOS-cursors"

			replace_with_real_files() {
				local target_path=$1

				if [ -L "$target_path" ]; then
					$DRY_RUN_CMD unlink "$target_path"
				fi

				$DRY_RUN_CMD mkdir -p "$(dirname "$target_path")"
				$DRY_RUN_CMD cp -rLT "${we10xos-cursors}/share/icons/$THEME_NAME" "$target_path"
				$DRY_RUN_CMD chmod -R u+rwX "$target_path"
			}

			replace_with_real_files "$HOME/.local/share/icons/$THEME_NAME"
			replace_with_real_files "$HOME/.icons/$THEME_NAME"
		'';

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