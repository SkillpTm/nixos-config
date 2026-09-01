set GREEN "\033[1;32m"
set RED "\033[1;31m"
set RESET "\033[0m"

function get_ip
	set -l current_ip (curl -s --connect-timeout 1 --max-time 2 ifconfig.me)

	if test -z "$current_ip"
		echo "Offline"
	else
		echo "$current_ip"
	end
end

argparse --max-args 1 -x s,o,r 's/status' 'o/off' 'r/reconnect' -- $argv
or exit 1

set allowed_codes ch de jp kr uk us # list of allowed country codes
set target_code "de" # default country (no input)

if set -q _flag_s; or set -q _flag_o; or set -q _flag_r; and test (count $argv) -gt 0
	echo -e "$RED""Flags cannot be used alongside a country code""$RESET"
	exit 1
end

set active_service (systemctl list-units --type=service --state=active | string match -r 'wg-quick-surfshark-[a-z]+\.service')
set active_code (string replace -r 'wg-quick-surfshark-(.*)\.service' '$1' "$active_service")

if test "$active_code" = ""
	set active_code "off"
end

if set -q _flag_s
	if test "$active_code" != "off"
		echo -e "Status:  ""$GREEN""connected ($active_code)""$RESET"
	else
		echo -e "Status:  ""$RED""disconnected""$RESET"
	end
	echo -e "IP:      $(get_ip)"
	exit 0
end

if set -q _flag_o
	if test "$active_code" = "off"
		echo -e "$RED""Already disconnected""$RESET"
		echo -e "IP:      $(get_ip)"
	else
		sudo systemctl stop $active_service
		echo -e "$RED""Disconnected:  $active_code --> off""$RESET"
		echo -e "IP:            $(get_ip)"
	end
	exit 0
end

if set -q _flag_r
	if test "$active_code" = "off"
		echo -e "$RED""Cannot reconnect, already disconnected""$RESET"
		echo -e "IP:      $(get_ip)"
		exit 0
	end
	set target_code $active_code
end

if test (count $argv) -gt 0;
	set target_code (string lower $argv[1])
end

if not contains -- $target_code $allowed_codes
	echo -e "$RED""'$target_code' is not a valid country code""$RESET"
	echo "Allowed codes are: $allowed_codes"
	exit 1
end

if test "$active_code" != "off"
	sudo systemctl stop $active_service
end

sudo systemctl start wg-quick-surfshark-$target_code.service

if systemctl is-active --quiet wg-quick-surfshark-$target_code.service
	echo -e "$GREEN""Connected:  $active_code --> $target_code""$RESET"
	echo -e "IP:         $(get_ip)"
else
	echo -e "$RED""Failed to connect ($target_code)""$RESET"
	echo -e "IP:         $(get_ip)"
end