{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
	pname = "naver-whale";
	version = "4.36.368.7";

	src = pkgs.fetchurl {
		url = "https://update.whale.naver.net/downloads/installers/naver-whale-stable_amd64.deb";
		# Ensure you use the SRI hash you generated earlier
		sha256 = "0v84abngbb5jkh40rcsfvvccxyhzza3qnwxm5w60hb230hii326h"; 
	};

	nativeBuildInputs = with pkgs; [
		autoPatchelfHook
		binutils
		makeWrapper
		xz
		gnutar
	];

	buildInputs = with pkgs; [
		alsa-lib
		at-spi2-atk
		at-spi2-core
		atk
		cairo
		cups
		dbus
		expat
		fontconfig
		freetype
		gdk-pixbuf
		glib
		gtk3
		libGL
		libx11
		libxscrnsaver
		libxcomposite
		libxcursor
		libxdamage
		libxext
		libxfixes
		libxi
		libxrandr
		libxrender
		libxtst
		libdrm
		libnotify
		libuuid
		libxcb
		libxkbcommon
		mesa
		nspr
		nss
		pango
		systemd
		wayland
		xdg-utils
		libkrb5
		keyutils
	];

	# This ignores the Qt shims that were causing the build to fail
	autoPatchelfIgnoreMissingDeps = [
		"libQt6Core.so.6"
		"libQt6Gui.so.6"
		"libQt6Widgets.so.6"
		"libQt5Core.so.5"
		"libQt5Gui.so.5"
		"libQt5Widgets.so.5"
	];

	unpackPhase = ''
		ar x $src
		tar -xvf data.tar.xz --no-same-owner --no-same-permissions
	'';

	installPhase = ''
		mkdir -p $out/bin $out/share/applications
		cp -rp opt/naver/whale/* $out/

		# Wrap the binary to include necessary runtime paths and flags
		makeWrapper $out/naver-whale $out/bin/naver-whale \
			--prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath buildInputs}" \
			--add-flags "--no-sandbox" \
			--add-flags "--test-type"

		# Fix the desktop file to point to our wrapped binary
		cp usr/share/applications/naver-whale.desktop $out/share/applications/
		substituteInPlace $out/share/applications/naver-whale.desktop \
			--replace "/usr/bin/naver-whale" "$out/bin/naver-whale"
	'';

	meta = with pkgs.lib; {
		description = "Naver Whale Browser";
		homepage = "https://whale.naver.com/";
		license = licenses.unfree;
		platforms = [ "x86_64-linux" ];
	};
}