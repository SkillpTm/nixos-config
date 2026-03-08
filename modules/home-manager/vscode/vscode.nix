{ pkgs, inputs, ... }:

let
	marketplace = inputs.vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in
{
	home.packages = [ pkgs.nixd ];

	programs.vscode = {
		enable = true;
		profiles.default = {
			userSettings = builtins.fromJSON (builtins.readFile ./settings.json);

			extensions = with pkgs.vscode-extensions; [
				dbaeumer.vscode-eslint
				docker.docker
				eamodio.gitlens
				ecmel.vscode-html-css
				formulahendry.auto-rename-tag
				github.copilot-chat
				golang.go
				marketplace.google.geminicodeassist
				jnoortheen.nix-ide
				mechatroner.rainbow-csv
				marketplace.mrmlnc.vscode-scss
				ms-azuretools.vscode-containers
				ms-azuretools.vscode-docker
				ms-python.debugpy
				ms-python.isort
				ms-python.pylint
				ms-python.python
				ms-python.vscode-pylance
				pkief.material-icon-theme
				ritwickdey.liveserver
				zainchen.json
			];
		};
	};
}