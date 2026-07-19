{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
		vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		plasma-manager = {
			url = "github:nix-community/plasma-manager";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
	};

	outputs = {
		nixpkgs, home-manager, ...
	} @inputs: 
	let
		nixosVersion = "26.05";
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