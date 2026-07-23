{ me, pkgs, ... }:

{
	home-manager.users.${me} = { lib, ... }: {
		home.activation.copyWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
			$DRY_RUN_CMD mkdir -p $HOME/.local/share/wallpapers

			$DRY_RUN_CMD cp -f ${../../assets/wallpapers/Cheshire.jpg} $HOME/.local/share/wallpapers/Cheshire.jpg
			$DRY_RUN_CMD cp -f ${../../assets/wallpapers/Ryujin.jpeg} $HOME/.local/share/wallpapers/Ryujin.jpeg
			$DRY_RUN_CMD cp -f ${../../assets/wallpapers/Stage.jpeg} $HOME/.local/share/wallpapers/Stage.jpeg

			$DRY_RUN_CMD chmod u+w $HOME/.local/share/wallpapers/Cheshire.jpg
			$DRY_RUN_CMD chmod u+w $HOME/.local/share/wallpapers/Ryujin.jpeg
			$DRY_RUN_CMD chmod u+w $HOME/.local/share/wallpapers/Stage.jpeg
		'';

		xdg.configFile = {
			"autostart/discord-canary.desktop".source = "${pkgs.discord-canary}/share/applications/discord-canary.desktop";
			"autostart/localsend.desktop".source = "${pkgs.localsend}/share/applications/localsend.desktop";
			"autostart/spotify.desktop".source = "${pkgs.spotify}/share/applications/spotify.desktop";
			"autostart/tutanota-desktop.desktop".source = "${pkgs.tutanota-desktop}/share/applications/tutanota-desktop.desktop";
		};
	};
}