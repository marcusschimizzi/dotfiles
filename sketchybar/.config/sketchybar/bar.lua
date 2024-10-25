local colors = require("colors")

sbar.bar({
	topmost = "window",
	height = 40,
	color = colors.bar.bg,
	border_color = colors.bar.border,
	blur_radius = 20,
	sticky = true,
	font_smoothing = true,
	padding_left = 2,
	padding_right = 2,
})
