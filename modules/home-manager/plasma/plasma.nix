{ pkgs, inputs, ... }:

{
	imports = [
		inputs.plasma-manager.homeManagerModules.plasma-manager
	];

	programs.plasma = {
		enable = true;
		desktop.mouseActions.middleClick = null;
	};
}