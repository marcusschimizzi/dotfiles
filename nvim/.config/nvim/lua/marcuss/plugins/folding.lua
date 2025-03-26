return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  event = "BufReadPost",
  config = function()
    -- Get fold appearance
    local handler = function(virtualText, lnum, endLnum, width, truncate)
      local newVirtualText = {}
      local suffix = (' 󰁂 %d lines'):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtualText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)

        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtualText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtualText, {chunkText, hlGroup})
          chunkWidth = vim.fn.strdisplaywidth(chunkText)

          -- If the text was truncated, add an ellipsis
          if curWidth + chunkWidth < targetWidth then
            suffix = ' ...' .. suffix
          end

          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtualText, {suffix, "MoreMsg"})
      return newVirtualText
    end

    -- Configure ufo
    require("ufo").setup({
      fold_virt_text_handler = handler,
      provider_selector = function(bufnr, filetype, buftype)
        return {"treesitter", "indent"}
      end,
      open_fold_hl_timeout = 150,
      close_fold_kinds = {"imports", "comment"},
      preview = {
        win_config = {
          border = {"", "─", "", "", "", "─", "", ""},
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        }
  }
    })

    -- Fold keymaps
    vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    -- vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        -- If no fold, perform the normal K behavior
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek fold or hover" })

    vim.keymap.set("n", "z<CR>", function()
      require("ufo").peekFoldedLinesUnderCursorj()
    end, { desc = "Peek fold" })

    -- Set folding options
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Fancy folding characters
    vim.opt.fillchars:append {
      fold = " ",
      foldopen = "▼",
      foldclose = "►",
      foldsep = "│",
    }

    -- Disable folding in large files for performance
    vim.api.nvim_create_autocmd("BufReadPre", {
      callback = function(event)
        local file_size_limit = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, event.match)

        if ok and stats and stats.size > file_size_limit then
          vim.opt_local.foldenable = false
        end
      end,
    })
  end,
}
