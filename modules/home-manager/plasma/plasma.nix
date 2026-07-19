{ pkgs, inputs, ... }:

{
	imports = [
		inputs.plasma-manager.homeModules.plasma-manager
	];

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
				LC_TIME = "de_DE.UTF-8";
			};
		};

		kscreenlocker = {
			autoLock = false;
			timeout = 0;
		};

		panels = [
			{
				location = "bottom";
				height = 44;

				widgets = [
					{
						kickoff = {
							icon = "nix-snowflake";
						};
					}

					"org.kde.plasma.pager"

					{
						iconTasks = {
							launchers = [
								"applications:kitty.desktop"
								"applications:org.kde.dolphin.desktop"
								"applications:code.desktop"
								"applications:discord-canary.desktop"
								"applications:naver-whale.desktop"
							];
						};
					}

					"org.kde.plasma.panelspacer"

					{
						systemTray = {
							items = {
								shown = [
									"tutanota-desktop"
									"discord-canary"
									"org.kde.plasma.clipboard"
									"org.kde.plasma.volume"
									"org.kde.plasma.networkmanagement"
								];
								
								hidden = [
									"org.kde.plasma.battery"
									"org.kde.plasma.devicenotifier"
									"org.kde.plasma.displayconfiguration"
									"org.kde.plasma.notifications"
									"org.kde.plasma.weather"
								];
							};
						};
					}

					"org.kde.plasma.digitalclock"
					"org.kde.plasma.showdesktop"
				];
			}
		];

		powerdevil.AC = {
			autoSuspend.action = "nothing";
			dimDisplay.enable = false;
			powerButtonAction = "shutDown";
			turnOffDisplay.idleTimeout = "never";
		};

		workspace = {
			theme = "breeze-dark";

			cursor = {
				theme = "We10XOS-cursors";
				size = 24;
			};
		};
	};
}