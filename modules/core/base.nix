{ inputs, me, pkgs, originalNixosVersion, ... }:

{
	imports = [ inputs.home-manager.nixosModules.home-manager ];

	boot.kernelPackages = pkgs.linuxPackages_latest;
	console.keyMap = "de";
	networking.networkmanager.enable = true;
	nixpkgs.config.allowUnfree = true;
	security.rtkit.enable = true;
	system.stateVersion = originalNixosVersion;
	time.timeZone = "Europe/Berlin";
	virtualisation.docker.enable = true;

	environment.systemPackages = with pkgs; [
		_7zz
		(if stdenv.hostPlatform.isx86_64 then btop-rocm else btop)
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
					package = if pkgs.stdenv.hostPlatform.isx86_64 then pkgs.btop-rocm else pkgs.btop;
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

	programs = {
		git.enable = true;
		ssh.knownHosts."github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
	};

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
