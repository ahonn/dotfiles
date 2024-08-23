local M = {
  'kevinhwang91/nvim-ufo',
  Event = 'BufReadPre',
  dependencies = {
    'kevinhwang91/promise-async'
  },
  init = function()
    local fcs = vim.opt.fillchars:get()
    local function get_fold(lnum)
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then return ' ' end
      return vim.fn.foldclosed(lnum) == -1 and fcs.foldopen or fcs.foldclose
    end

    _G.get_statuscol = function()
      return get_fold(vim.v.lnum) .. " %s%=%{v:relnum?v:relnum:v:lnum} "
    end

    vim.o.statuscolumn = "%!v:lua.get_statuscol()"
  end,
  config = function()
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' ↙ %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    ---@diagnostic disable-next-line: missing-fields
    require('ufo').setup({
      fold_virt_text_handler = handler,
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "neo-tree" },
      callback = function()
        require("ufo").detach()
        vim.opt_local.foldenable = false
        vim.wo.foldcolumn = "0"
      end
    })
  end,
  keys = {
    { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
    { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
    { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Open folds except kinds' },
    { 'zm', function() require('ufo').closeFoldsWith() end, desc = 'Close folds with' },
  },
}

return M
