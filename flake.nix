{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
		home-manager.url = "github:nix-community/home-manager/release-25.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
	};

	outputs = {
		nixpkgs, home-manager, ...
	} @inputs: 
	let
		nixosVersion = "25.11";
		me = "skillp";
	in
	{
		nixosConfigurations = {
			desktop = nixpkgs.lib.nixosSystem {
				specialArgs = {
					inherit
						inputs
						nixosVersion
						me;
				};
				modules = [
					./hosts/desktop/configuration.nix
					home-manager.nixosModules.home-manager
					./hosts/desktop/home.nix
				];
			};
		};
	};
}