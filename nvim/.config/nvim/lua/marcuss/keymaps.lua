-----------------------------------------------------
--- Basic Keymaps
-----------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Helper function to map keys
local function map(mode, lhs, rhs, opt)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Stay in indent mode when indenting
map("v", "<", "<gv", { desc = "Decrease indent and stay in visual mode" })
map("v", ">", ">gv", { desc = "Increase indent and stay in visual mode" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

