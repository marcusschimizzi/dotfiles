local settings = require("settings")

local icons = {
	sf_symbols = {
		loading = "􀖇",
		apple = "􀣺",
		aerospace = "􀏝",
		battery = {
			_100 = "",
			_75 = "􀺸",
			_50 = "􀺶",
			_25 = "􀛩",
			_0 = "􀛪",
			charging = "􀢋",
		},
		wifi = {
			upload = "􀄨",
			download = "􀄩",
			connected = "􀙇",
			disconnected = "􀙈",
			router = "􁓤",
			vpn = "􀒲",
		},
		chevron = {
			left = "􀆉",
			right = "􀆊",
		},
		media = {
			play = "􀊃",
			pause = "􀊆",
		},
	},

	nerdfont = {
		apple = "",
		battery = {
			_100 = "",
			_75 = "",
			_50 = "",
			_25 = "",
			_0 = "",
			charging = "",
		},
		wifi = {
			upload = "",
			download = "",
			connected = "󰖩",
			disconnected = "󰖪",
			router = "Missing Icon",
		},
		aerospace = "",
		chevron = {
			left = "",
			right = "",
		},
		media = {
			play = "",
			pause = "",
		},
	},
}

if not (settings.icons == "NerdFont") then
	return icons.sf_symbols
else
	return icons.nerdfont
end
