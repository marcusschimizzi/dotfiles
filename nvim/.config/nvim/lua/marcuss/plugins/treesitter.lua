return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-context",
    "windwp/nvim-ts-autotag",
    "virchau13/tree-sitter-astro",
  },
  config = function()
    vim.defer_fn(function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rust",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
          "astro",
        },

        -- Install parsers synchronously
        sync_install = false,

        -- Automatically install missing parsers
        auto_install = true,

        -- Indentation based on treesitter for the = operator
        indent = { enable = true },

        -- Enhanced syntax highlighting
        highlight = {
          enable = true,

          additional_vim_regex_highlighting = { "markdown", "astro" },
        },

        autotag = {
          enable = true,
        },
      })
    end, 0)
  end,
}
