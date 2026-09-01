{ me, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		kitty

		(pkgs.writers.writeFishBin "nx-whale-update"
			(builtins.readFile ../../commands/nx-whale-update.fish)
		)
	];

	programs = {
		partition-manager.enable = true;

		localsend = {
			enable = true;
			openFirewall = true;
		};
	};

	users.users.${me}.packages = with pkgs; [
		discord-canary
		mpv
		onlyoffice-desktopeditors
		spotify
		tutanota-desktop
		wofi-emoji
		xeyes

		(callPackage ./whale.nix {})
	];
}