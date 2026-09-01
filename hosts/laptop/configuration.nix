{ me, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/apps/base.nix
		../../modules/apps/vscode.nix
		../../modules/apps/whale.nix
		../../modules/core/base.nix
		../../modules/core/fish.nix
		../../modules/core/wireguard.nix
		../../modules/graphical/base.nix
		../../modules/graphical/plasma-base.nix
		../../modules/graphical/plasma-mobile.nix
	];

	networking.hostName = "laptop";
	users.users.${me}.packages = with pkgs; [ libreoffice-qt-fresh ];

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 8 * 1024;
	}];
}