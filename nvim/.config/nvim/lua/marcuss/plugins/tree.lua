return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function ()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 30,
        signcolumn = "yes",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { "^.git$", "node_modules", "^.DS_Store$" },
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          resize_window = true,
        },
      },
      on_attach = function (bufnr)
       local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }    
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close directory'))
        vim.keymap.set('n', 'gh', api.tree.toggle_hidden_filter, opts('Toggle hidden files'))
      end,
    })

    vim.keymap.set('n', '<leader>ee', ':NvimTreeToggle<CR>', { desc = "Toggle file explorer", silent = true })
  end
}
