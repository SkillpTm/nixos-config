# NixOS Configuration

My personal NixOS configuration, it's nothing really special or fancy, just a normal setup. This is **not** a template, but you can of course still use it as one. It's sometimes not very adabtable and has some hardcoded lines. This is a work in progress (and always will be).

## Custom Commands

There are some custom scripts in [./commands.](https://github.com/SkillpTm/nixos-config/tree/main/commands) These, I personally feel, elevate the experince of handling some of the more clunky CLI command setups required in day to day NixOS. They get automatically registered as commands by NixOS.

<sup><sub>Disclaimer: for some of these scripts it's imperative that this repo was cloned into your home directory. Also the directory still needs to be called *nixos-config*!</sub></sup>

- `nx-clean`: A simple cleanup script which clears up storage. It empties the trash, clears journalctl (except last 30 days), runs nix-collect-garbage (also except last 30 days) and will nix store optimise.
- `nx-rebuild`: Automatically handels git changing and nixos-rebuilds. Has flags to be ran for boot (-b), switch (-s, or no flag), test (-t) and update (-u, a nix flake update + switch).
- `nx-wg`: Handels wireguard setup for surfshark. This requires conf files at */root/wireguard/surfshark-COUNTRY_CODE.conf* and also interface registration in the [core](https://github.com/SkillpTm/nixos-config/blob/main/modules/nixos/core.nix).
- `nx-whale-update`: Handels updating of the Naver Whale browser. It will download the entire .deb from Naver every time you run this. (It's best to check in the browser for updates first)