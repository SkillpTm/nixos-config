{ pkgs, inputs, nixosVersion, me, ... }:

{
	imports = [
		../../modules/home-manager/core.nix
	];
}