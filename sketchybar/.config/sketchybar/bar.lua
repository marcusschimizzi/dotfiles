local colors = require("colors")

sbar.bar({
	topmost = "window",
	height = 40,
	color = colors.transparent,
	blur_radius = 20,
	font_smoothing = true,
	padding_left = 2,
	padding_right = 2,
	notch_width = 200,
})
