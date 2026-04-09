local wezterm = require("wezterm")

return {
	-- 🔤 Font (IDE-like rendering)
	font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"Fira Code",
		"IBM Plex Mono",
	}),
	font_size = 14,
	line_height = 1.25,

	-- 🧼 Clean look
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	enable_scroll_bar = false,

	-- 🎨 Color scheme (Tokyo Night vibes)
	color_scheme = "rose-pine",

	colors = {
		-- 🌑 Dark background
		background = "#0b0911",
	},

	-- 🧭 Padding (tight like IDEs)
	window_padding = {
		left = 6,
		right = 6,
		top = 6,
		bottom = 6,
	},

	-- 🧱 TERM (important for Neovim)
	term = "xterm-256color",

	-- 🔔 Disable bell (important for sanity)
	audible_bell = "Disabled",

	-- 🧪 True color (Neovim needs this)
	-- enable_wayland = true,

	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",
}
