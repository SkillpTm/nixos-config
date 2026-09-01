{ me, pkgs, ... }:

{
	programs = {
		firefox.enable = true;
		gpu-screen-recorder.enable = true;

		steam = {
			enable = true;
			dedicatedServer.openFirewall = true;
			remotePlay.openFirewall = true;
		};
	};

	users.users.${me}.packages = with pkgs; [
		brave
		ffmpeg
		haruna
		krita
		qbittorrent
		rocmPackages.rocm-smi
		shotcut
		vlc
		yt-dlp
	];
}