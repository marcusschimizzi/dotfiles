return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set a header
    dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("f", " Find file", ":Telescope find_files<CR>"),
      dashboard.button("e", " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", " Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("t", " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("c", " Configuration", ":e ~/.config/nvim <CR>"),
      dashboard.button("p", " Plugin configuration", ":e ~/.config/nvim/lua/marcuss/plugins <CR>"),
      dashboard.button("q", " Quit neovim", ":qa<CR>"),
    }

    -- Footer with some stats
    local function footer()
      local datetime = os.date(" %d-%m-%Y %H:%M:%S")
      local version = vim.version()
      -- local nvim_version = " v" .. version.major .. "." .. version.minor "." .. version.patch
      local plugins_count = " " .. #vim.tbl_keys(require("lazy").plugins()) .. " plugins"

      return datetime .. "  " .. plugins_count
    end

    dashboard.section.footer.val = footer()

    -- Customize colors
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function ()
        vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#4caf8f" })
        vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#61B8D6" })
        vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#9D7CD8" })
      end
    })

    -- Open alpha when all buffers are closed
    vim.api.nvim_create_autocmd("User", {
      pattern = "BDeletePost*",
      callback = function (event)
        local fallback_name = vim.api.nvim_buf_get_name(event.buf)
        local fallback_ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
        local fallback_on_empty = fallback_name == "" and fallback_ft == ""

        if fallback_on_empty then
          -- No more buffers, open alpha
          vim.cmd("Alpha")
        end
      end,
    })

    alpha.setup(dashboard.opts)

    vim.cmd([[
      autocmd FileType alpha setlocal nofoldenable
    ]])
  end
}
