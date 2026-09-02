{ me, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ wl-clipboard ];

	boot = {
		binfmt.emulatedSystems = [ "aarch64-linux" ];
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

	home-manager.users.${me}.xdg = {
		configFile."mimeapps.list".force = true;
		dataFile = { "icons/hicolor/scalable/apps/nixos-logo-white.png".source = ../../assets/logos/nixos-white.png; };

		mimeApps = {
			enable = true;

			defaultApplications = {
				"text/html" = "naver-whale.desktop";
				"x-scheme-handler/http" = "naver-whale.desktop";
				"x-scheme-handler/https" = "naver-whale.desktop";
				"x-scheme-handler/about" = "naver-whale.desktop";
				"x-scheme-handler/unknown" = "naver-whale.desktop";

				"x-scheme-handler/mailto" = "tuta-desktop.desktop";

				"image/jpeg" = "org.kde.gwenview.desktop";
				"image/png" = "org.kde.gwenview.desktop";
				"image/gif" = "org.kde.gwenview.desktop";
				"image/webp" = "org.kde.gwenview.desktop";

				"audio/mpeg" = "mpv.desktop";
				"audio/x-wav" = "mpv.desktop";
				"audio/flac" = "mpv.desktop";
				"video/mp4" = "mpv.desktop";
				"video/x-matroska" = "mpv.desktop";
				"video/webm" = "mpv.desktop";

				"text/plain" = "code.desktop";

				"application/pdf" = "naver-whale.desktop";

				"inode/directory" = "org.kde.dolphin.desktop";

				"application/zip" = "org.kde.ark.desktop";
				"application/x-tar" = "org.kde.ark.desktop";
				"application/x-compressed-tar" = "org.kde.ark.desktop";

				"x-scheme-handler/geo" = "openstreetmap.desktop";
			};
		};
	};

	services = {
		displayManager.sddm.enable = true;
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
}