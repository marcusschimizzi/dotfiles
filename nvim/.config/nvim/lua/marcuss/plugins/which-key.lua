return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function ()
    local which_key = require('which-key')

    which_key.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = false,
          suggestions = 20,
        },
      }
    })
  end
}
