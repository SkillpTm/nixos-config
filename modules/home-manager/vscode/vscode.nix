{ inputs, lib, pkgs, ... }:

let
	marketplace = inputs.vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in
{
	home = {
		packages = [ pkgs.nixd ];

		activation.setupVSCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
			TARGET="$HOME/.config/Code/User/settings.json"

			cp -f "${./settings.json}" "$TARGET"
			chmod u+w "$TARGET"
		'';
	};

	programs.vscode = {
		enable = true;
		profiles.default.extensions = with pkgs.vscode-extensions; [
			christian-kohler.path-intellisense
			dbaeumer.vscode-eslint
			docker.docker
			eamodio.gitlens
			ecmel.vscode-html-css
			editorconfig.editorconfig
			formulahendry.auto-rename-tag
			github.copilot-chat
			golang.go
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
			ms-python.vscode-python-envs
			pkief.material-icon-theme
			ritwickdey.liveserver
			zainchen.json
		];
	};
}