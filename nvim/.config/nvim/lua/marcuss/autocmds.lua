-----------------------------------------------------
--- AUTOCMDS (Automatic Commands)
-----------------------------------------------------

-- Create an autocommand group
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
  desc = "Highlight yanked text",
})

-- Automatically reload file if changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup,
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
  desc = "Check if file changed externally",
})

-- Use markdown parser for mdx files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mdx",
  callback = function()
    vim.defer_fn(function ()
      vim.treesitter.language.register("markdown", "mdx")
    end, 100)
  end,
  desc = "Use markdown Treesitter parser for MDX files"
})
