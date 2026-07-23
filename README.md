# NixOS Configuration

My personal NixOS configuration, it's nothing really special or fancy, just a normal setup. This is **not** a template, but you can of course still use it as one. It's sometimes not very adabtable and has some hardcoded lines. This is a work in progress (and always will be).

## Custom Scripts

There are some custom scripts in [./commands.](https://github.com/SkillpTm/nixos-config/tree/main/commands) These, I personally feel, elevate the experince of handling some of the more clunky CLI command setups required in day to day NixOS. They get automatically registered as commands by NixOS.

<sup><sub>Disclaimer: for some of these scripts it's imperative that this repo was cloned into your home directory. Also the directory still needs to be called *nixos-config*!</sub></sup>

- `nx-clean`: A simple cleanup script which clears up storage. It empties the trash, clearn journalctl (except last 30 days), runs nix-collect-garbage (also except last 30 days) and nix store optimise.
- `nx-rebuild`: Automatically handels git changing and the system around nixos-rebuilds. Has flags to be ran for boot (-b), switch (-s, or no flag), test (-t) and update (-u, a nix flake update + switch).
- `nx-wg`: Handels wireguard setup for surfshark, requires according conf files at */root/wireguard/surfshark-COUNTRY_CODE.conf*
- `nx-whale-update`: Handels updating of the Naver Whale browser. It will download the entire .deb from Naver every time you run this. (best to check in the browser for updates first)