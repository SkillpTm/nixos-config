{ inputs, ... }:

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

			# /home/skillp/.config/dolphinrc
			dolphinrc = {
				"MainWindow" = {
					BrowseThroughArchives = true;
					CloseSplitViewChoice = "InactiveView";
					MenuBar = "Enabled";
					OpenNewTabAfterLastTab = true;
					ShowFullPath = true;
					ShowFullPathInTitlebar = true;
					TabStyle = "FixedSize";
				};

				"General" = {
					AlwaysShowTabBar = true;
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

		workspace = {
			theme = "breeze-dark";

			cursor = {
				theme = "We10XOS-cursors";
				size = 24;
			};
		};
	};
}