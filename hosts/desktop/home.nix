{ me, pkgs, ... }:

{
	home-manager.users.${me} = { ... }: {
		xdg = {
			configFile = {
				"autostart/discord-canary.desktop".source = "${pkgs.discord-canary}/share/applications/discord-canary.desktop";
				"autostart/spotify.desktop".source = "${pkgs.spotify}/share/applications/spotify.desktop";
				"autostart/tutanota-desktop.desktop".source = "${pkgs.tutanota-desktop}/share/applications/tutanota-desktop.desktop";
			};

			dataFile = {
				"wallpapers/Cheshire.jpg".source = ../../assets/wallpapers/Cheshire.jpg;
				"wallpapers/Ryujin.jpeg".source = ../../assets/wallpapers/Ryujin.jpeg;
				"wallpapers/Stage.jpeg".source = ../../assets/wallpapers/Stage.jpeg;
			};
		};
	};
}