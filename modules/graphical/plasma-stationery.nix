{ lib, me, pkgs, ... }:

let
	sharedPanel = screen: {
		inherit screen;

		location = "bottom";
		floating = false;
		height = 44;

		widgets = [
			{
				kickoff.icon = "nixos-logo-white";
			}

			"org.kde.plasma.pager"

			{
				iconTasks = {
					appearance = {
						showTooltips = true;
						highlightWindows = true;
					};

					launchers = [
						"applications:kitty.desktop"
						"applications:org.kde.dolphin.desktop"
						"applications:code.desktop"
						"applications:discord-canary.desktop"
						"applications:spotify.desktop"
						"applications:naver-whale.desktop"
					];
				};
			}

			"org.kde.plasma.panelspacer"

			{
				systemTray.items = {
					shown = [
						"tutanota-desktop"
						"discord-canary"
						"spotify"
						"localsend"
						"org.kde.plasma.clipboard"
						"org.kde.plasma.volume"
						"org.kde.plasma.networkmanagement"
					];

					hidden = [
						"org.kde.plasma.battery"
						"org.kde.plasma.brightness"
						"org.kde.plasma.devicenotifier"
						"org.kde.plasma.displayconfiguration"
						"org.kde.plasma.nightcolorcontrol"
						"org.kde.plasma.notifications"
						"org.kde.plasma.weather"
					];
				};
			}

			{
				digitalClock.date.format.custom = "ddd dd.MM.yyyy";
			}

			"org.kde.plasma.showdesktop"
		];
	};
in
{
	home-manager.users.${me} = { lib, ... }: {
		home.activation.copyWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
			$DRY_RUN_CMD mkdir -p $HOME/.local/share/wallpapers

			$DRY_RUN_CMD cp -f ${../../assets/wallpapers/Cheshire.jpg} $HOME/.local/share/wallpapers/Cheshire.jpg
			$DRY_RUN_CMD cp -f ${../../assets/wallpapers/Ryujin.jpeg} $HOME/.local/share/wallpapers/Ryujin.jpeg
			$DRY_RUN_CMD cp -f ${../../assets/wallpapers/Stage.jpeg} $HOME/.local/share/wallpapers/Stage.jpeg

			$DRY_RUN_CMD chmod u+w $HOME/.local/share/wallpapers/Cheshire.jpg
			$DRY_RUN_CMD chmod u+w $HOME/.local/share/wallpapers/Ryujin.jpeg
			$DRY_RUN_CMD chmod u+w $HOME/.local/share/wallpapers/Stage.jpeg
		'';

		programs.plasma = {
			kscreenlocker = {
				autoLock = false;
				timeout = 0;
			};

			panels = [
				(sharedPanel 0)
				(sharedPanel 1)
				(sharedPanel 2)
			];

			powerdevil.AC = {
				autoSuspend.action = "nothing";
				dimDisplay.enable = false;
				powerButtonAction = "shutDown";
				turnOffDisplay.idleTimeout = "never";
			};
		};

		xdg.configFile = {
			"autostart/discord-canary.desktop".source = "${pkgs.discord-canary}/share/applications/discord-canary.desktop";
			"autostart/localsend.desktop".source = "${pkgs.localsend}/share/applications/localsend.desktop";
			"autostart/spotify.desktop".source = "${pkgs.spotify}/share/applications/spotify.desktop";
			"autostart/tutanota-desktop.desktop".source = "${pkgs.tutanota-desktop}/share/applications/tutanota-desktop.desktop";
		};
	};
}