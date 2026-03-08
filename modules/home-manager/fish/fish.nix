{ lib, pkgs, ... }:

{
	home.activation.tide-configure = lib.hm.dag.entryAfter ["writeBoundary"] ''
		${pkgs.fish}/bin/fish -c "tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Light --show_time='24-hour format' --classic_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Sparse --icons='Many icons' --transient=No"
	'';

	programs.fish = {
		enable = true;
		interactiveShellInit = builtins.readFile ./config.fish;

		plugins = [
			{
				name = "tide";
				src = pkgs.fishPlugins.tide.src;
			}
		];
	};
}