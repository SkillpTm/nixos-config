{ pkgs ? import <nixpkgs> {} }:

let
  hash = builtins.replaceStrings ["\n" "\r"] ["" ""] (builtins.readFile ./naver-whale-hash.txt);

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
    '';
  };

in
pkgs.buildFHSEnv {
  name = "naver-whale";
  
  targetPkgs = pkgs: with pkgs; [
    whale-deb

	# nix alien dependencies
	alsa-lib-with-plugins.out
    at-spi2-atk.out
    cairo.out
    cups.lib
    dbus.lib
    expat.out
    glib.out
    libgbm.out
    libx11.out
    libxcb.out
    libxcomposite.out
    libxdamage.out
    libxext.out
    libxfixes.out
    libxkbcommon.out
    libxrandr.out
    nspr.out
    nss_latest.out
    pango.out
    systemdLibs.out

    # libs required to make hardware acceleration possible
    libglvnd
    libGL
    mesa
    vulkan-loader
    wayland
    libdrm
    curl
    libva
  ];

  runScript = pkgs.writeScript "naver-whale-wrapper" ''
	#!/usr/bin/env bash
    exec ${whale-deb}/opt/naver/whale/whale \
      --enable-gpu \
      --ozone-platform=wayland \
      --disable-gpu-sandbox \
      --use-gl=angle \
      --use-angle=vulkan \
      --enable-features=Vulkan,VaapiVideoDecoder \
      --disable-gpu-memory-buffer-video-frames \
      "$@"
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/32x32/apps $out/share/icons/hicolor/256x256/apps
    ln -s ${whale-deb}/share/applications/*.desktop $out/share/applications/
    ln -s ${whale-deb}/opt/naver/whale/product_logo_32.png $out/share/icons/hicolor/32x32/apps/naver-whale.png
    ln -s ${whale-deb}/opt/naver/whale/product_logo_256.png $out/share/icons/hicolor/256x256/apps/naver-whale.png
  '';
}