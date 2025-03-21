local settings = require("settings")
local colors = require("colors")

sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14.0,
		},
		color = colors.fg,
		highlight_color = colors.fg_highlight,
		padding_left = settings.padding,
		padding_right = settings.padding,
		background = { image = { corner_radius = 12 } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 12.0,
		},
		color = colors.fg,
		highlight_color = colors.fg_highlight,
		padding_left = settings.label.padding_left,
		padding_right = settings.label.padding_right,
	},
	background = {
		color = colors.bar.bg,
		height = 28,
		corner_radius = 12,
		border_width = 0,
		border_color = colors.border,
		image = {
			corner_radius = 12,
			border_color = colors.border,
			border_width = 2,
		},
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.popup.border,
			color = colors.popup.bg,
			shadow = { drawing = true },
		},
		blur_radius = 50,
	},
	padding_left = 4,
	padding_right = 4,
	scroll_texts = true,
})
