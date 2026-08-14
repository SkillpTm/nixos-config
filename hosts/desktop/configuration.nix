{ inputs, me, pkgs, ... }:

let
	mkAutomount = uuid: fsType: {
		device = "/dev/disk/by-uuid/${uuid}";
		fsType = fsType;
		options = [ "nofail" ];
	};

in
{
	fileSystems."/home/${me}/Drives/C"  = mkAutomount "7258F95D58F92111" "ntfs";
	fileSystems."/home/${me}/Drives/F" = mkAutomount "44573fa4-1d1a-4af2-875c-5ae368b8c2d0" "ext4";
	fileSystems."/home/${me}/Drives/G"  = mkAutomount "d2bbc553-0afb-4a7f-9216-4c36d52e6a87" "ext4";
	networking.hostName = "desktop";
	virtualisation.docker.enable = true;

	imports = [
		./hardware-configuration.nix
		./home.nix
		../../modules/nixos/core.nix
		../../modules/home-manager/home.nix
	];

	programs = {
		firefox.enable = true;
		gpu-screen-recorder.enable = true;

		steam = {
			enable = true;
			dedicatedServer.openFirewall = true;
			remotePlay.openFirewall = true;
		};
	};

	swapDevices = [{
		device = "/var/lib/swapfile";
		size = 16 * 1024;
	}];

	users.users.${me} = {
		description = "Skillp";
		extraGroups = [ "docker" ];

		packages = with pkgs; [
			brave
			ffmpeg
			go
			haruna
			krita
			qbittorrent
			shotcut
			vlc
			yt-dlp
		];
	};
}