local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

sbar.add("item", { width = 5 })

local apple = sbar.add("item", "apple", {
	icon = {
		font = { size = 16.0 },
		string = icons.apple,
		padding_right = 8,
		padding_left = 8,
		color = colors.white,
	},
	label = { drawing = false },
	background = {
		drawing = false,
		color = colors.bg,
		border_color = colors.black,
		border_width = 1,
	},
	padding_right = 1,
	padding_left = 1,
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

sbar.add("bracket", { apple.name }, {
	background = {
		drawing = false,
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

sbar.add("item", { width = 7 })
