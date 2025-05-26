return {
  "marcusschimizzi/umbra.nvim",
  name = "umbra",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    require("umbra").setup()

    vim.cmd.colorscheme("umbra")
  end
}
