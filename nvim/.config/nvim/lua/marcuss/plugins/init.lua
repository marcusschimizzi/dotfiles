return {
  "nvim-lua/plenary.nvim",
  { "b0o/SchemaStore.nvim" },
  {
    "nvim-tree/nvim-web-devicons",
    config = function ()
      require('nvim-web-devicons').setup({
        strict = true,
        override_by_extension = {
          astro = {
            icon = "🚀",
            color = "#ef8547",
            name = "astro",
          },
          mdx = {
            icon = "📝",
            color = "#519aba",
            name = "mdx",
          },
        },
      })
    end
  }
}
