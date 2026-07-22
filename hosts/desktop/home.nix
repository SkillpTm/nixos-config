{ me, pkgs, ... }:

{
	home-manager.users.${me} = { lib, ... }: {
		home.activation.copyWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
			mkdir -p $HOME/.local/share/wallpapers

			cp -f ${../../assets/wallpapers/Cheshire.jpg} $HOME/.local/share/wallpapers/Cheshire.jpg
			cp -f ${../../assets/wallpapers/Ryujin.jpeg} $HOME/.local/share/wallpapers/Ryujin.jpeg
			cp -f ${../../assets/wallpapers/Stage.jpeg} $HOME/.local/share/wallpapers/Stage.jpeg

			chmod u+w $HOME/.local/share/wallpapers/Cheshire.jpg
			chmod u+w $HOME/.local/share/wallpapers/Ryujin.jpeg
			chmod u+w $HOME/.local/share/wallpapers/Stage.jpeg
		'';

		xdg.configFile = {
			"autostart/discord-canary.desktop".source = "${pkgs.discord-canary}/share/applications/discord-canary.desktop";
			"autostart/spotify.desktop".source = "${pkgs.spotify}/share/applications/spotify.desktop";
			"autostart/tutanota-desktop.desktop".source = "${pkgs.tutanota-desktop}/share/applications/tutanota-desktop.desktop";
		};
	};
}