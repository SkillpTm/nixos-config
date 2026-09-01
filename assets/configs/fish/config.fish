if status is-interactive
	set -g fish_greeting
	fastfetch

	if type -q nx-wg
		nx-wg -s
	end
end