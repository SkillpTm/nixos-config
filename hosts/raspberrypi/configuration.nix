{ me, ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/core/base.nix
		../../modules/core/fish.nix
		../../modules/graphical/not-graphical.nix
	];

	networking.hostName = "raspberrypi";

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 4 * 1024;
	}];
}