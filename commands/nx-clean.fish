set GREEN "\033[1;32m"
set RESET "\033[0m"
set before_kb (df -k --output=used / | tail -n 1 | string trim)

rm -rf ~/.local/share/Trash/files ~/.local/share/Trash/info ~/.local/share/Trash/expunged
mkdir -p ~/.local/share/Trash/{files,info,expunged}

sudo journalctl --vacuum-time=30d
sudo nix-collect-garbage --delete-older-than 30d
sudo nix store optimise
sudo /run/current-system/bin/switch-to-configuration boot

set after_kb (df -k --output=used / | tail -n 1 | string trim)
set saved_kb (math "$before_kb - $after_kb")

if test $saved_kb -gt (math "1024 * 1024")
    set saved "$(math -s 2 "$saved_kb / (1024 * 1024)") GiB"
else if test $saved_kb -gt 1024
    set saved "$(math -s 2 "$saved_kb / 1024") MiB"
else
    set saved "$saved_kb KiB"
end

echo -e "$GREEN""Succesfully freed up $saved of space""$RESET"