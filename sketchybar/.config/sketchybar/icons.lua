local settings = require("settings")

local icons = {
	sf_symbols = {
		loading = "􀖇",
		apple = "􀣺",
		aerospace = "􀏝",
		battery = {
			_100 = "􀛨",
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
		volume = {
			_100 = "􀊩",
			_66 = "􀊧",
			_33 = "􀊥",
			_10 = "􀊡",
			_0 = "􀊣",
		},
		chevron = {
			left = "􀆉",
			right = "􀆊",
		},
		media = {
			play = "􀊃",
			pause = "􀊆",
		},
		cpu = "􀫥",
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
		volume = {
			_100 = "",
			_66 = "",
			_33 = "",
			_10 = "",
			_0 = "",
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
		cpu = "",
	},
}

if not (settings.icons == "NerdFont") then
	return icons.sf_symbols
else
	return icons.nerdfont
end
