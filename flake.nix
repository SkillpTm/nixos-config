{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
		nixos-hardware.url = "github:nixos/nixos-hardware/master";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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

	outputs = { nixpkgs, nixpkgs-unstable, nixos-hardware, ... } @ inputs:
		let
			overlay-unstable = final: prev: {
				unstable = import nixpkgs-unstable {
					system = prev.stdenv.hostPlatform.system;
					config.allowUnfree = true;
				};
			};
		in {
			nixosConfigurations = {
				desktop = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					specialArgs = {
						inherit inputs;
						me = "skillp";
						originalNixosVersion = "25.11";
					};
					modules = [
						{ nixpkgs.overlays = [ overlay-unstable ]; }
						./hosts/desktop/configuration.nix
					];
				};
				laptop = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					specialArgs = {
						inherit inputs;
						me = "skillp";
						originalNixosVersion = "26.05";
					};
					modules = [
						{ nixpkgs.overlays = [ overlay-unstable ]; }
						./hosts/laptop/configuration.nix
					];
				};
				raspberrypi = nixpkgs.lib.nixosSystem {
					system = "aarch64-linux";
					specialArgs = {
						inherit inputs;
						me = "skillp";
						originalNixosVersion = "26.05";
					};
					modules = [
						nixos-hardware.nixosModules.raspberry-pi-4
						./hosts/raspberrypi/configuration.nix
					];
				};
			};
		};
}