{ config, lib, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

	boot = {
		initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
		kernelModules = [ "kvm-intel" ];
	};

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/19753b1a-2333-4552-90ee-4e957ff0b95d";
		fsType = "btrfs";
		options = [ "subvol=root" "compress-force=zstd" "noatime" "discard=async" ];
	};

	fileSystems."/home" = {
		device = "/dev/disk/by-uuid/19753b1a-2333-4552-90ee-4e957ff0b95d";
		fsType = "btrfs";
		options = [ "subvol=home" "compress-force=zstd" "noatime" "discard=async" ];
	};

	fileSystems."/nix" = {
		device = "/dev/disk/by-uuid/19753b1a-2333-4552-90ee-4e957ff0b95d";
		fsType = "btrfs";
		options = [ "subvol=nix" "compress-force=zstd" "noatime" "discard=async" ];
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/112C-CE8F";
		fsType = "vfat";
		options = [ "fmask=0077" "dmask=0077" ];
	};
}
