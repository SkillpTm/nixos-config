{ config, inputs, lib, me, pkgs, ... }:

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
	services.desktopManager.plasma6.enable = true;

	environment = {
		systemPackages = with pkgs; [ kdePackages.kdbusaddons ];

		plasma6.excludePackages = with pkgs.kdePackages; [
			elisa
			kate
			khelpcenter
			kinfocenter
			konsole
			okular
			qrca
		];
	};

	home-manager.users.${me} = { lib, config, ... }: {
		imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

		home = {
    		file.".face".source = ../../assets/logos/nixos.png;
			file.".face.icon".source = ../../assets/logos/nixos.png;
			packages = [ we10xos-cursors ];

			activation.setupDolphinPlaces = lib.hm.dag.entryAfter ["writeBoundary"] ''
				TARGET="$HOME/.local/share/user-places.xbel"

				$DRY_RUN_CMD mkdir -p "$HOME/.local/share"
				$DRY_RUN_CMD cp -f "${../../assets/configs/plasma/user-places.xbel}" "$TARGET"
				$DRY_RUN_CMD chmod u+w "$TARGET"
			'';

			activation.copyWe10XOSCursors = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
				TARGET_CONF="$HOME/.config/kcminputrc"
				TARGET_ICONS="$HOME/.local/share/icons"

				$DRY_RUN_CMD mkdir -p "$HOME/.local/share/icons"
				$DRY_RUN_CMD cp -Rf "${we10xos-cursors}/share/icons/We10XOS-cursors" "$TARGET_ICONS"
				$DRY_RUN_CMD chmod -R u+w "$TARGET_ICONS"

				$DRY_RUN_CMD mkdir -p "$HOME/.config"
				$DRY_RUN_CMD cp -f "${../../assets/configs/plasma/kcminputrc}" "$TARGET_CONF"
				$DRY_RUN_CMD chmod u+w "$TARGET_CONF"
			'';
		};

		programs.plasma = {
			enable = true;
			input.keyboard.options = [ "caps:none" "lv3:caps_switch" ];

			configFile = {
				kactivitymanagerdrc.Plugins."org.kde.ActivityManager.ResourceScoringEnabled" = false;
				klipperrc.General.MaxClipItems = 2048;
				kwinrc.Effect-overview.BorderActivate = 9;
				kwinrc.Effect-shakecursor.Magnification = 10;
				kwinrc.Wayland.EnablePrimarySelection = false;
				PlasmaUserFeedback.Global.FeedbackLevel = 64;

				# /home/skillp/.config/dolphinrc
				dolphinrc = {
					"MainWindow" = {
						MenuBar = "Enabled";
					};

					"General" = {
						AlwaysShowTabBar = true;
						BrowseThroughArchives = true;
						CloseSplitViewChoice = "InactiveView";
						HomeUrl = "file://${config.home.homeDirectory}/Downloads";
						OpenNewTabAfterLastTab = true;
						RememberOpenedTabs = false;
						ShowFullPath = true;
						ShowFullPathInTitlebar = true;
						TabStyle = "FixedSize";
					};
				};

				kdeglobals = {
					KDE.AnimationDurationFactor = 0.0;

					General = {
						TerminalApplication = "kitty";
						TerminalService = "kitty.desktop";
					};
				};

				plasma-localerc.Formats = {
					LANG = "en_US.UTF-8";
					LC_ADDRESS = "de_DE.UTF-8";
					LC_IDENTIFICATION = "de_DE.UTF-8";
					LC_MEASUREMENT = "de_DE.UTF-8";
					LC_MONETARY = "de_DE.UTF-8";
					LC_NAME = "de_DE.UTF-8";
					LC_NUMERIC = "de_DE.UTF-8";
					LC_PAPER = "de_DE.UTF-8";
					LC_TELEPHONE = "de_DE.UTF-8";
					LC_TIME = "en_GB.UTF-8";
				};
			};

			workspace = {
				theme = "breeze-dark";

				cursor = {
					theme = "We10XOS-cursors";
					size = 24;
				};
			};
		};
	};

	users.users.${me}.packages = with pkgs; [
		kdePackages.filelight
		kdePackages.kcalc
		kdePackages.kcharselect
		kdePackages.isoimagewriter
	];
}