return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- load this before all other start plugins
		config = function()
			local transparent = true

			require("tokyonight").setup({
				style = "night",
				transparent = transparent,
				styles = {
					sidebars = transparent and "transparent" or "dark",
					floats = transparent and "transparent" or "dark",
				},
			})

			-- load the colorscheme
			vim.cmd("colorscheme tokyonight")
		end,
	},
}
