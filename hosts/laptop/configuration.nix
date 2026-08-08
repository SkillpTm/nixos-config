{ me, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./home.nix
		../../modules/nixos/core.nix
		../../modules/home-manager/home.nix
	];

	networking.hostName = "laptop";

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 8 * 1024;
	}];

	users.users.${me} = {
		description = "Skillp";

		packages = with pkgs; [
			libreoffice-qt-fresh
		];
	};
}