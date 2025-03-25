-- init.lua - Minimal Neovim Configuration
--
-- Author: Marcus Schimizzi
-- Created: 03/24/25

-----------------------------------------------------
--- Basic Editor Settings
-----------------------------------------------------

-- Line Numbers
vim.opt.number = true		-- Show line numbers
vim.opt.relativenumber = true	-- Use relative line numbers

-- Tabs & Indentation
vim.opt.tabstop = 2		-- 2 spaces for tabs
vim.opt.shiftwidth = 2		-- 2 spaces for indentation
vim.opt.expandtab = true	-- Use spaces instead of tabs
vim.opt.autoindent = true	-- Copy indent from current line when starting a new line

-- Line wrapping
vim.opt.wrap = false		-- Disable line wrapping

-- Search settings
vim.opt.ignorecase = true	-- Ignore case when searching
vim.opt.smartcase = true	-- Override ignorecase if pattern has uppercase
vim.opt.hlsearch = true		-- Highlight search results
vim.opt.incsearch = true	-- Incremental search

-- Appearance
vim.opt.termguicolors = true	-- Enable 24-bit RGB colors
vim.opt.signcolumn = "yes"	-- Always show the sign column
vim.opt.scrolloff = 8		-- Min # of lines to keep above/below the cursor
vim.opt.colorcolumn = "80"	-- Display a color column at 80
vim.opt.cmdheight = 1       -- Command line height

-- Decrease update time
vim.opt.updatetime = 250  -- Faster completion
vim.opt.timeoutlen = 300 -- Time to wait for mapped sequence to complete

-- Clipboard
vim.opt.clipboard = "unnamedplus"   -- Use system clipboard

-- Window splitting
vim.opt.splitright = true     -- Split windows to the right
vim.opt.splitbelow = true     -- Split windows below

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

-----------------------------------------------------
--- NEWRW Settings
-----------------------------------------------------

-- Use tree style listing
vim.g.netrw_liststyle = 3

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

