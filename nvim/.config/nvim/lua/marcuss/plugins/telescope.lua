return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Import telescope module
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")
    local builtin = require("telescope.builtin")

    -- Configure telescope
    telescope.setup({
      defaults = {
        -- Default settings for all pickers
        prompt_prefix = " ",
        path_display = { "truncate" },
        selection_strategy = "reset",

        mappings = {
          i = {
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-c>"] = actions.close,
            ["<Up>"] = actions.move_selection_previous,
            ["<Down>"] = actions.move_selection_next,
            ["<CR>"] = actions.select_default,
            ["<M-p>"] = action_layout.toggle_preview,
          },
        },

        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
        file_ignore_patterns = {
          "node_modules",
          "%.git/",
          "%.DS_Store",
          "%.settings/",
          "target/",
          "build/",
          "dist/",
          "%.class",
          "%.o",
          "%.meta",
        },
        set_env = { ["COLORTERM"] = "truecolor" }, -- Enable colors
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      },

      -- Configure individual pickers
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          additional_args = function(opts)
            return { "--hidden" }
          end
        },
        buffers = {
          show_all_buffers = true,
          sort_lastused = true,
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        git_files = {
          hidden = true,
          show_untracked = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },

      -- Configure extensions
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          hijack_netrw = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    -- load extensions
    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("ui-select")

    -- Key mappings
    local nmap = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { desc = desc })
    end

    -- File navigation
    nmap("<leader>ff", builtin.find_files, "Find files")
    nmap("<leader>fr", builtin.oldfiles, "Find recent files")
    nmap("<leader>fb", builtin.buffers, "Find buffers")
    nmap("<leader>fg", builtin.live_grep, "Find via grep")
    nmap("<leader>fh", builtin.help_tags, "Find help")
    nmap("<leader>f/", builtin.current_buffer_fuzzy_find, "Find in current buffer")
    nmap("<leader>fs", builtin.lsp_document_symbols, "Find document symbols")
    nmap("<leader>fS", builtin.lsp_dynamic_workspace_symbols, "Find workspace symbols")
    nmap("<leader>fm", builtin.marks, "Find marks")

    -- Git integration
    nmap("<leader>gc", builtin.git_commits, "Git commits")
    nmap("<leader>gb", builtin.git_branches, "Git branches")
    nmap("<leader>gs", builtin.git_status, "Git status")
    nmap("<leader>gf", builtin.git_files, "Git files")

    -- Other useful pickers
    nmap("<leader>fk", builtin.keymaps, "Find keymaps")
    nmap("<leader>fo", builtin.vim_options, "Find vim options")
    nmap("<leader>fc", builtin.commands, "Find commands")

    -- File browser
    nmap("<leader>fe", telescope.extensions.file_browser.file_browser, "File browser")

    -- Use telescope for vim.ui.select
    vim.ui.select = require("telescope.themes").get_dropdown()
  end,
}
