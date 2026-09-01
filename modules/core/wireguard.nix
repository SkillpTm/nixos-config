{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		(pkgs.writers.writeFishBin "nx-wg"
			(builtins.readFile ../../commands/nx-wg.fish)
		)
	];

	networking.wg-quick.interfaces = {
		surfshark-ch = {
			autostart = false;
			configFile = "/root/wireguard/surfshark-ch.conf";
		};

		surfshark-de = {
			autostart = true;
			configFile = "/root/wireguard/surfshark-de.conf";
		};

		surfshark-jp = {
			autostart = false;
			configFile = "/root/wireguard/surfshark-jp.conf";
		};

		surfshark-kr = {
			autostart = false;
			configFile = "/root/wireguard/surfshark-kr.conf";
		};

		surfshark-uk = {
			autostart = false;
			configFile = "/root/wireguard/surfshark-uk.conf";
		};

		surfshark-us = {
			autostart = false;
			configFile = "/root/wireguard/surfshark-us.conf";
		};
	};
}