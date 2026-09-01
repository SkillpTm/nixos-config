{ me, ... }:

let
	mkAutomount = uuid: fsType: {
		device = "/dev/disk/by-uuid/${uuid}";
		fsType = fsType;
		options = [ "nofail" ];
	};
in
{
	imports = [
		./hardware-configuration.nix
		../../modules/apps/base.nix
		../../modules/apps/utility.nix
		../../modules/apps/vscode.nix
		../../modules/core/base.nix
		../../modules/core/fish.nix
		../../modules/core/wireguard.nix
		../../modules/graphical/base.nix
		../../modules/graphical/plasma-base.nix
		../../modules/graphical/plasma-stationery.nix
	];

	fileSystems."/home/${me}/Drives/C"  = mkAutomount "7258F95D58F92111" "ntfs";
	fileSystems."/home/${me}/Drives/F" = mkAutomount "44573fa4-1d1a-4af2-875c-5ae368b8c2d0" "ext4";
	fileSystems."/home/${me}/Drives/G"  = mkAutomount "d2bbc553-0afb-4a7f-9216-4c36d52e6a87" "ext4";
	networking.hostName = "desktop";

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 16 * 1024;
	}];
}