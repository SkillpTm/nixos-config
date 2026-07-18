{ config, pkgs, me, ... }:

{
	boot = {
		kernelPackages = pkgs.linuxPackages_latest;

		loader = {
			efi.canTouchEfiVariables = true;
			systemd-boot.enable = true;
		};
	};

	console.keyMap = "de";

	environment = {
		plasma6.excludePackages = with pkgs.kdePackages; [
			elisa
			kate
			khelpcenter
			kinfocenter
		];

		systemPackages = with pkgs; [
			git
			kitty
			nvd

			(pkgs.writers.writeFishBin "nswitch"
				(builtins.readFile ../../commands/nswitch.fish)
			)
			(pkgs.writers.writeFishBin "nupdate"
				(builtins.readFile ../../commands/nupdate.fish)
			)
		];
	};

	i18n = {
		defaultLocale = "en_US.UTF-8";

		extraLocaleSettings = {
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

	networking.networkmanager.enable = true;

	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	nixpkgs.config.allowUnfree = true;

	programs = {
		fish.enable = true;
		partition-manager.enable = true;
	};

	security.rtkit.enable = true;

	services = {
		desktopManager.plasma6.enable = true;
		displayManager.sddm.enable = true;
		printing.enable = true;
		pulseaudio.enable = false;

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		xserver = {
			enable = true;
			excludePackages = [ pkgs.xterm ];

			xkb = {
				layout = "de";
				variant = "";
			};
		};
	};

	system.stateVersion = "25.11";

	time.timeZone = "Europe/Berlin";

	users.users.${me} = {
		isNormalUser = true;
		shell = pkgs.fish;

		extraGroups = [
			"networkmanager"
			"wheel"
		];

		packages = with pkgs; [
			bitwarden-desktop
			discord-canary
			docker
			fastfetch
			gimp-with-plugins
			kdePackages.isoimagewriter
			mpv
			python314
			tutanota-desktop

			(callPackage ../custom/whale/whale.nix { })
		];
	};
}