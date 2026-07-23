{ inputs, lib, me, originalNixosVersion, pkgs, ... }:

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

in
{
	imports = [
		inputs.home-manager.nixosModules.home-manager
	];

	home-manager = {
		backupFileExtension = "backup";
		extraSpecialArgs = { inherit inputs originalNixosVersion me; };
		useGlobalPkgs = true;
		useUserPackages = true;

		users.${me} = { lib, ... }: {
			home = {
				packages = [ pkgs.nerd-fonts.meslo-lg ];
				stateVersion = originalNixosVersion;

				activation.setupMyFoldersAndRepos = lib.hm.dag.entryAfter ["writeBoundary"] ''
					mkdir -p $HOME/Code/github.com/SkillpTm

					${repoCloneCommands}
				'';
			};

			imports = [
				./dolphin/dolphin.nix
				./fish/fish.nix
				./plasma/cursor.nix
				./plasma/plasma.nix
				./vscode/vscode.nix
			];

			programs = {
				btop = {
					enable = true;
					package = pkgs.btop-rocm;
					settings.shown_boxes = "cpu mem net proc gpu0";
				};

				git = {
					enable = true;

					settings = {
						extraConfig = {
							init.defaultBranch = "main";
							push.autoSetupRemote = true;
						};

						user = {
							email = "99091714+SkillpTm@users.noreply.github.com";
							name = "SkillpTm";
						};
					};
				};
			};

			xdg = {
				configFile."mimeapps.list".force = true;

				dataFile = {
					"icons/hicolor/scalable/apps/nixos-logo-white.png".source = ../../assets/logos/nixos-white.png;
				};

				mimeApps = {
					enable = true;

					defaultApplications = {
					"text/html" = "naver-whale.desktop";
					"x-scheme-handler/http" = "naver-whale.desktop";
					"x-scheme-handler/https" = "naver-whale.desktop";
					"x-scheme-handler/about" = "naver-whale.desktop";
					"x-scheme-handler/unknown" = "naver-whale.desktop";

					"x-scheme-handler/mailto" = "tuta-desktop.desktop";

					"image/jpeg" = "org.kde.gwenview.desktop";
					"image/png" = "org.kde.gwenview.desktop";
					"image/gif" = "org.kde.gwenview.desktop";
					"image/webp" = "org.kde.gwenview.desktop";

					"audio/mpeg" = "mpv.desktop";
					"audio/x-wav" = "mpv.desktop";
					"audio/flac" = "mpv.desktop";
					"video/mp4" = "mpv.desktop";
					"video/x-matroska" = "mpv.desktop";
					"video/webm" = "mpv.desktop";

					"text/plain" = "code.desktop";

					"application/pdf" = "naver-whale.desktop";

					"inode/directory" = "org.kde.dolphin.desktop";

					"application/zip" = "org.kde.ark.desktop";
					"application/x-tar" = "org.kde.ark.desktop";
					"application/x-compressed-tar" = "org.kde.ark.desktop";

					"x-scheme-handler/geo" = "openstreetmap.desktop";
					};
				};
			};
		};
	};
}