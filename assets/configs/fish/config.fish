if status is-interactive
	set -g fish_greeting

	if test (id -u) -eq 0
		return
	end

	fastfetch

	if type -q nx-wg
		nx-wg -s
	end
end