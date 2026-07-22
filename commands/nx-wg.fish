set GREEN "\033[1;32m"
set RED "\033[1;31m"
set RESET "\033[0m"

argparse 's/status' 'o/off' -- $argv
or exit 1

set allowed_codes ch de jp kr uk us # list of allowed server codes
set target_code "de" # default server (no input)

set -l flags_count 0
if set -q _flag_s; set flags_count (math $flags_count + 1); end
if set -q _flag_o; set flags_count (math $flags_count + 1); end

if test $flags_count -gt 1
	echo -e "$RED""Flags -s and -o cannot be used together""$RESET"
	exit 1
end

if test $flags_count -eq 1; and test (count $argv) -gt 0
	echo -e "$RED""Flags cannot be used alongside a country code""$RESET"
	exit 1
end

set active_service (systemctl list-units --type=service --state=active | string match -r 'wg-quick-surfshark-[a-z]+\.service')
set active_code (string replace -r 'wg-quick-surfshark-(.*)\.service' '$1' "$active_service")

if test "$active_code" = ""
	set active_code "off"
end

if set -q _flag_s
	set current_ip (curl -s ifconfig.me)

	if test "$active_code" != "off"
		echo -e "Status:  ""$GREEN""connected ($active_code)""$RESET"
		echo -e "IP:      $current_ip"
	else
		echo -e "Status:  ""$RED""disconnected ($active_code)""$RESET"
		echo -e "IP:      $current_ip"
	end
	exit 0
end

if set -q _flag_o
	if test "$active_code" = "off"
		echo -e "$RED""Already disconnected""$RESET"
	else
		sudo systemctl stop $active_service
		echo -e "$GREEN""Disconnected: $active_code --> off""$RESET"
	end
	exit 0
end

if test (count $argv) -gt 0;
	set target_code (string lower $argv[1])
end

if not contains -- $target_code $allowed_codes
	echo -e "$RED""'$target_code' is not a valid server code""$RESET"
	echo "Allowed codes are: $allowed_codes"
	exit 1
end

if test "$active_code" = "$target_code"
	echo -e "$GREEN""Already connected ($target_code)""$RESET"
	exit 0
end

if test "$active_code" != "off"
	sudo systemctl stop $active_service
end

sudo systemctl start wg-quick-surfshark-$target_code.service

if systemctl is-active --quiet wg-quick-surfshark-$target_code.service
    echo -e "$GREEN""Connected: $active_code --> $target_code""$RESET"
else
    echo -e "$RED""Failed to connect ($target_code)""$RESET"
end