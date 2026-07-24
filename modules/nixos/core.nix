{ config, me, pkgs, originalNixosVersion, ... }:

{
	console.keyMap = "de";
	nixpkgs.config.allowUnfree = true;
	security.rtkit.enable = true;
	system.stateVersion = originalNixosVersion;
	time.timeZone = "Europe/Berlin";

	boot = {
		kernelPackages = pkgs.linuxPackages_latest;

		loader = {
			efi.canTouchEfiVariables = true;

			grub = {
				enable = true;
				device = "nodev";
				efiSupport = true;
				useOSProber = true;
			};
		};
	};

	environment = {
		plasma6.excludePackages = with pkgs.kdePackages; [
			elisa
			kate
			khelpcenter
			kinfocenter
			konsole
			okular
			qrca
		];

		systemPackages = with pkgs; [
			_7zz
			btop-rocm
			file
			git
			kitty
			kdePackages.kdbusaddons
			nvd
			wl-clipboard

			(pkgs.writers.writeFishBin "nx-clean"
				(builtins.readFile ../../commands/nx-clean.fish)
			)
			(pkgs.writers.writeFishBin "nx-rebuild"
				(builtins.readFile ../../commands/nx-rebuild.fish)
			)
			(pkgs.writers.writeFishBin "nx-wg"
				(builtins.readFile ../../commands/nx-wg.fish)
			)
			(pkgs.writers.writeFishBin "nx-whale-update"
				(builtins.readFile ../../commands/nx-whale-update.fish)
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
			LC_TIME = "en_GB.UTF-8";
		};
	};

	networking = {
		networkmanager.enable = true;

		wg-quick.interfaces = {
			surfshark-ch = {
				autostart = false;
				configFile = "/root/wireguard/surfshark-ch.conf";
			};

			surfshark-de = {
				autostart = true;
				configFile = "/root/wireguard/surfshark-de.conf";
			};

			surfshark-jp = {
				autostart = false;
				configFile = "/root/wireguard/surfshark-jp.conf";
			};

			surfshark-kr = {
				autostart = false;
				configFile = "/root/wireguard/surfshark-kr.conf";
			};

			surfshark-uk = {
				autostart = false;
				configFile = "/root/wireguard/surfshark-uk.conf";
			};

			surfshark-us = {
				autostart = false;
				configFile = "/root/wireguard/surfshark-us.conf";
			};
		};
	};

	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	programs = {
		fish.enable = true;
		partition-manager.enable = true;

		localsend = {
			enable = true;
			openFirewall = true;
		};
	};

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

	users.users.${me} = {
		isNormalUser = true;
		shell = pkgs.fish;

		extraGroups = [
			"networkmanager"
			"wheel"
		];

		packages = with pkgs; [
			cloc
			discord-canary
			docker
			fastfetch
			kdePackages.filelight
			kdePackages.kcalc
			kdePackages.kcharselect
			kdePackages.isoimagewriter
			mpv
			onlyoffice-desktopeditors
			python314
			spotify
			tutanota-desktop
			wofi-emoji
			xeyes

			(callPackage ../custom/whale/naver-whale.nix {})
		];
	};
}
