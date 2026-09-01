{ inputs, lib, me, pkgs, ... }:

let
	repos = [
		{ url = "https://github.com/SkillpTm/Bolt"; dest = "$HOME/Code/github.com/SkillpTm/Bolt"; }
		{ url = "https://github.com/SkillpTm/NixOS-Config"; dest = "$HOME/Code/github.com/SkillpTm/NixOS-Config"; }
		{ url = "https://github.com/SkillpTm/SkillpTm"; dest = "$HOME/Code/github.com/SkillpTm/SkillpTm"; }
		{ url = "https://github.com/SkillpTm/Somi-Bot"; dest = "$HOME/Code/github.com/SkillpTm/Somi-Bot"; }
	];

	mkCloneScript = repo: ''
		if [ ! -d "${repo.dest}/.git" ]; then
			env GIT_TERMINAL_PROMPT=0 GIT_ASKPASS= ${pkgs.git}/bin/git -c credential.helper= clone --quiet ${repo.url} ${repo.dest} || true
		fi
	'';

	repoCloneCommands = lib.concatMapStrings mkCloneScript repos;
	marketplace = inputs.vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace;
in
{
	users.users.${me}.packages = with pkgs; [
		python314
		go
	];

	home-manager = {
		users.${me} = { lib, ... }: {
			home = {
				packages = [ pkgs.nixd ];

				activation.setupVSCodeSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
					TARGET="$HOME/.config/Code/User/settings.json"

					$DRY_RUN_CMD cp -f "${../../assets/configs/vscode/settings.json}" "$TARGET"
					$DRY_RUN_CMD chmod u+w "$TARGET"
				'';

				activation.setupMyFoldersAndRepos = lib.hm.dag.entryAfter ["writeBoundary"] ''
					mkdir -p $HOME/Code/github.com/SkillpTm

					${repoCloneCommands}
				'';
			};

			programs.vscode = {
				enable = true;
				package = pkgs.unstable.vscode;
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
					ms-vscode-remote.remote-containers
					pkief.material-icon-theme
					ritwickdey.liveserver
					zainchen.json
				];
			};
		};
	};
}