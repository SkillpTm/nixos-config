{ pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ kitty.terminfo ];

	boot.loader = {
		efi.canTouchEfiVariables = false;
		generic-extlinux-compatible.enable = true;
		grub.enable = false;
	};

	services.openssh = {
		enable = true;

		settings = {
			PasswordAuthentication = true;
			PermitRootLogin = "no";
		};

		extraConfig = ''
			AllowUsers *@192.168.*.* *@10.*.*.* *@172.16.*.*
		'';
	};
}