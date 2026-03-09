{ pkgs, inputs, ... }:

{
	imports = [
		inputs.plasma-manager.homeModules.plasma-manager
	];

	programs.plasma = {
		enable = true;
		input.keyboard.options = [ "caps:none" "lv3:caps_switch" ];
	};
}