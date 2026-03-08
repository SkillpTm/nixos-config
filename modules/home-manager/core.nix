{ pkgs, inputs, nixosVersion, me, ... }:

{
	home-manager = {
		extraSpecialArgs = { inherit inputs; };
		useGlobalPkgs = true;
		useUserPackages = true;

		users.${me} = { ... }: {
			home.stateVersion = nixosVersion;
			home.packages = [ pkgs.nerd-fonts.meslo-lg ];
			imports = [
				./fish/fish.nix
				./vscode/vscode.nix
			];
		};
	};
}