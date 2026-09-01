{ inputs, me, pkgs, originalNixosVersion, ... }:

{
	imports = [ inputs.home-manager.nixosModules.home-manager ];

	console.keyMap = "de";
	networking.networkmanager.enable = true;
	nixpkgs.config.allowUnfree = true;
	programs.git.enable = true;
	security.rtkit.enable = true;
	system.stateVersion = originalNixosVersion;
	time.timeZone = "Europe/Berlin";
	virtualisation.docker.enable = true;

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

	environment.systemPackages = with pkgs; [
		_7zz
		btop-rocm
		file
		nvd
		mediainfo

		(pkgs.writers.writeFishBin "nx-clean"
			(builtins.readFile ../../commands/nx-clean.fish)
		)
		(pkgs.writers.writeFishBin "nx-rebuild"
			(builtins.readFile ../../commands/nx-rebuild.fish)
		)
	];

	home-manager = {
		backupFileExtension = "backup";
		extraSpecialArgs = { inherit inputs originalNixosVersion me; };
		useGlobalPkgs = true;
		useUserPackages = true;

		users.${me} = {
			home.stateVersion = originalNixosVersion;

			programs = {
				btop = {
					enable = true;
					package = pkgs.btop-rocm;
					settings.shown_boxes = "cpu mem net proc gpu0";
				};

				git = {
					enable = true;

					settings = {
						extraConfig = {
							init.defaultBranch = "main";
							push.autoSetupRemote = true;
						};

						user = {
							email = "99091714+SkillpTm@users.noreply.github.com";
							name = "SkillpTm";
						};
					};
				};
			};
		};
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

	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	users.users.${me} = {
		description = "Skillp";
		isNormalUser = true;

		extraGroups = [
			"docker"
			"networkmanager"
			"wheel"
		];

		packages = with pkgs; [
			cloc
			docker
			fastfetch
		];
	};
}