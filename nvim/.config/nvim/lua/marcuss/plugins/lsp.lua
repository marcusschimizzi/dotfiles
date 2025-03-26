return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Automatically install LSPs and related tools
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration for nvim
    { "folke/neodev.nvim" },

    -- For formatters and linters
    { "nvimtools/none-ls.nvim" },
    { "jay-babu/mason-null-ls.nvim" },

    -- Useful LSP-related code actions, diagnostics, etc
    {
      "nvimdev/lspsaga.nvim",
      event = "LspAttach",
      config = function()
        require("lspsaga").setup({
          ui = {
            border = "rounded",
          },
          symbol_in_winbar = {
            enable = true,
          },
          lightbulb = {
            enable = true,
            sign = true,
            virtual_text = false,
          },
        })
      end,
    },

    -- Enhanced LSP UIs
    { "ray-x/lsp_signature.nvim", opts = {} },

    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim", -- Icons in completion menu
      },
    },
  },
  config = function()
    -- Setup neodev
    require("neodev").setup({
      library = {
        plugins = { "nvim-dap-ui" },
        types = true,
      },
    })

    -- Setup mason to manage LSP servers, DAP servers, linters & formatters
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Setup mason-lspconfig for automatic LSP server installation
    require("mason-lspconfig").setup({
      ensure_installed = {
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "lua_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "bashls",
        "marksman",
        "tailwindcss",
        "astro",
        "emmet_ls",
      },
      -- Auto-install servers
      automatic_installation = true,
    })

    -- Setup null-ls for linting and formatting
    local null_ls = require("none-ls")

    null_ls.setup({
      sources = {
        -- Formatters
        null_ls.builtins.formatting.prettier.with({
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "html",
            "css",
            "astro",
            "mdx",
          },
        }), -- JS, TS, CSS, JSON, etc
        null_ls.builtins.formatting.black, -- Python
        null_ls.builtins.formatting.stylua, -- Lua

        -- Linters
        null_ls.builtins.diagnostics.eslint, -- JS, TS
        null_ls.builtins.diagnostics.flake8, -- Python
        null_ls.builtins.diagnostics.luacheck, -- Lua

        -- Code actions
        -- null_ls.builtins.code_actions.gitsigns,
      },
    })

    require("mason-null-ls").setup({
      ensure_installed = {
        "prettier",
        "stylua",
        "black",
        "eslint_d",
        "flake8",
        "luacheck",
      },
      automatic_installation = true,
      automatic_setup = true,
    })


    -- Global mappings with all LSP servers
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

    -- Enhanced LSP UI options
    vim.diagnostic.config({
      virtual_text = { spacing = 4, prefix = "●" },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- Change diagnostic symbols in the sign column
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Use LspAttach to map keys after language server attaches to the buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings
        local opts = { buffer = ev.buf }

        -- LSP Actions
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "Go to type definition" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Go to implementation" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Show references" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format { async = true }
        end, { buffer = ev.buf, desc = "Format buffer" })

        -- Enhanced lspsaga features
        vim.keymap.set("n", "<leader>K", "<cmd>Lspsaga hover_doc<CR>", { buffer = ev.buf, desc = "Enhanced hover" })
        vim.keymap.set("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", { buffer = ev.buf, desc = "Peek definition" })
        vim.keymap.set("n", "<leader>pt", "<cmd>Lspsaga peek_type_definition<CR>", { buffer = ev.buf, desc = "Peek type definition" })
        vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { buffer = ev.buf, desc = "Show outline" })

        -- Load nvim-lsp_signature for enhanced function signature help
        require("lsp_signature").on_attach({
          bind = true,
          handler_opts = {
            border = "rounded"
          },
        }, ev.buf)
      end,
    })

    -- Configure nvim-cmp for LSP-driven autocompletion
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load some nice snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item

        -- Tab navigation for cmp and luasnip
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
          { name = "buffer" },
        }),
      formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          menu = {
            buffer = "[Buf]",
            nvim_lsp = "[LSP]",
            luasnip = "[Snip]",
            path = "[Path]",
          },
        }),
      },
    })

    -- Set up cmdline completion
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
          { name = "cmdline" },
        }),
    })

    -- Set up completion for searches
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Setup individual language servers
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- TS/JS
    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      }
    })

    -- Astro
    lspconfig.astro.setup({
      capabilities = capabilities,
    })

    -- Lua
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    -- Html
    lspconfig.html.setup({
      capabilities = capabilities,
      filetypes = { "html", "astro" },
    })

    -- Css
    lspconfig.cssls.setup({
      capabilities = capabilities,
      filetypes = { "css", "scss", "less", "astro" },
    })

    -- Tailwind Css
    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      filetypes = { "html", "astro", "javascriptreact", "typescriptreact", "mdx" },
      init_options = {
        userLanguages = {
          astro = "html",
          mdx = "markdown",
        }
      }
    })

    -- JSON
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
}
