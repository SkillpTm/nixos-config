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

	outputs = { nixpkgs, home-manager, ... } @inputs: {
		nixosConfigurations = {
			desktop = nixpkgs.lib.nixosSystem {
				specialArgs = {
					inherit inputs;
					me = "skillp";
					originalNixosVersion = "25.11";
				};
				modules = [ ./hosts/desktop/configuration.nix ];
			};
		};
	};
}