local colors = {}

local theme = {
	white = 0xffe0def4,
	black = 0xff26233a,
	grey = 0xff7f8490,
	transparent = 0x00000000,

	red = 0xffeb6f92,
	blue = 0xff9ccfd8,
	green = 0xff31748f,
	yellow = 0xfff6c177,
	rose = 0xffebbcba,
	iris = 0xffc4a7e7,

	bar = {
		bg = 0xff191724,
		border = 0xff403d52,
	},

	popup = {
		bg = 0xff191724,
		border = 0xff7f8490,
	},

	bg = 0xff191724,
	bg2 = 0xff1f1d2e,
	bg3 = 0xff26233a,

	fg = 0xffe0def4,
	fg2 = 0xff908caa,
	fg3 = 0xff6e6a86,

	highlight = {
		low = 0xff21202e,
		med = 0xff403d52,
		high = 0xff524f67,
	},

	-- Base16 Default Dark Theme
	dark = 0xff181818,
	dark_grey = 0xff282828,
	grey = 0xff383838,
	light_grey = 0xff585858,
	dark_silver = 0xffb8b8b8,
	silver = 0xffd8d8d8,
	light_silver = 0xffe8e8e8,
	light = 0xfff8f8f8,
	red = 0xffab4642,
	orange = 0xffdc9656,
	yellow = 0xfff7ca88,
	green = 0xffa1b56c,
	cyan = 0xff86c1b9,
	blue = 0xff7cafc2,
	magenta = 0xffba8baf,
	brown = 0xffa16946,

	-- Special colors
	transparent = 0x00000000,
	black = 0xff000000,
	white = 0xffffffff,
	github_blue = 0xff4170ae,
}

local with_alpha = function(color, alpha)
	if alpha > 1.0 or alpha < 0.0 then
		return color
	end
	return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end
colors.with_alpha = with_alpha

for k, v in pairs(theme) do
	colors[k] = v
end

colors.fg = theme.silver
colors.fg_highlight = theme.github_blue
colors.fg_secondary = theme.silver
colors.bg = theme.black
colors.border = theme.dark
colors.active = theme.white

return colors
