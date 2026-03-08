{ config, pkgs, me, ... }:

{
	imports = [
		../../modules/nixos/core.nix

		./hardware-configuration.nix
	];

	networking.hostName = "desktop";

	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	programs = {
		firefox.enable = true;
	};

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 16 * 1024;
	}];

	users.users.${me} = {
		description = "Skillp";

		packages = with pkgs; [
			go
			steam
			vlc
		];
	};
}