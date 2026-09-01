{ pkgs, ... }:

let
	hash = builtins.replaceStrings ["\n" "\r"] ["" ""] (builtins.readFile ../../assets/configs/whale/naver-whale-hash.txt);

	whale-deb = pkgs.stdenv.mkDerivation rec {
		pname = "naver-whale-unwrapped";
		version = "latest";

		src = pkgs.fetchurl {
			name = "naver-whale-${builtins.substring 0 8 hash}.deb";
			url = "https://installer-whale.pstatic.net/downloads/installers/naver-whale-stable_amd64.deb";
			sha256 = hash;
		};

		nativeBuildInputs = [ pkgs.dpkg ];

		unpackPhase = ''
			dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
		'';

		installPhase = ''
			mkdir -p $out
			cp -r opt $out/opt
			cp -r usr/share $out/share

			substituteInPlace $out/share/applications/*.desktop \
				--replace "/usr/bin/naver-whale-stable" "naver-whale" \
				--replace "/usr/bin/naver-whale" "naver-whale"

			substituteInPlace $out/share/gnome-control-center/default-apps/naver-whale.xml \
				--replace "/opt/naver" "$out/opt/naver" || true
			substituteInPlace $out/share/menu/naver-whale.menu \
				--replace "/opt/naver" "$out/opt/naver" || true
		'';
	};

in
pkgs.buildFHSEnv {
	name = "naver-whale";

	targetPkgs = pkgs: with pkgs; [
		whale-deb

		alsa-lib-with-plugins
		at-spi2-core
		cairo
		coreutils
		cups.lib
		curl
		dbus.lib
		expat
		freetype
		fontconfig
		glib
		libdrm
		libgbm
		libGL
		libglvnd
		libpulseaudio
		libva
		libX11
		libxcb
		libXcomposite
		libXdamage
		libXext
		libXfixes
		libxkbcommon
		libXrandr
		mesa
		nspr
		nss
		pango
		pipewire
		udev
		vulkan-loader
		wayland
		xdg-utils
	];

	runScript = pkgs.writeScript "naver-whale-wrapper" ''
	#!/usr/bin/env bash
		exec ${whale-deb}/opt/naver/whale/whale \
			--enable-gpu \
			--ozone-platform-hint=auto \
			--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE \
			--disable-gpu-memory-buffer-video-frames \
			"$@"
	'';

	extraInstallCommands = ''
		mkdir -p $out/share/applications
		ln -s ${whale-deb}/share/applications/*.desktop $out/share/applications/

		for icon in 16 24 32 48 64 128 256; do
			mkdir -p $out/share/icons/hicolor/''${icon}x''${icon}/apps
			ln -s ${whale-deb}/opt/naver/whale/product_logo_$icon.png $out/share/icons/hicolor/''${icon}x''${icon}/apps/naver-whale.png
		done

		mkdir -p $out/opt/naver/whale
		ln -sf ${pkgs.xdg-utils}/bin/xdg-settings $out/opt/naver/whale/xdg-settings
		ln -sf ${pkgs.xdg-utils}/bin/xdg-mime $out/opt/naver/whale/xdg-mime
	'';

	meta = with pkgs.lib; {
		description = "Web browser by NAVER";
		homepage = "https://whale.naver.com";
		platforms = [ "x86_64-linux" ];
		mainProgram = "naver-whale";
	};
}