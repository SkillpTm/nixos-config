{ pkgs, inputs, nixosVersion, me, ... }:

{
	home-manager = {
		backupFileExtension = "backup";
		extraSpecialArgs = { inherit inputs; };
		useGlobalPkgs = true;
		useUserPackages = true;

		users.${me} = { ... }: {
			home.stateVersion = nixosVersion;
			home.packages = [ pkgs.nerd-fonts.meslo-lg ];

			imports = [
				./fish/fish.nix
				./plasma/plasma.nix
				./vscode/vscode.nix
			];

			xdg = {
				configFile = {
					"autostart/discord-canary.desktop".source = "${pkgs.discord-canary}/share/applications/discord-canary.desktop";
					"autostart/spotify.desktop".source = "${pkgs.spotify}/share/applications/spotify.desktop";
					"autostart/tutanota-desktop.desktop".source = "${pkgs.tutanota-desktop}/share/applications/tutanota-desktop.desktop";

					"mimeapps.list".force = true;
				};

				dataFile = {
					"icons/hicolor/scalable/apps/nixos-logo-white.png".source = ../../assets/logos/nixos-white.png;

					"wallpapers/Cheshire.jpg".source = ../../assets/wallpapers/Cheshire.jpg;
					"wallpapers/Ryujin.jpeg".source = ../../assets/wallpapers/Ryujin.jpeg;
					"wallpapers/Stage.jpeg".source = ../../assets/wallpapers/Stage.jpeg;
				};

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
		};
	};
}