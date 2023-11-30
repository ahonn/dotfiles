local M = {
  "neoclide/coc.nvim",
  branch = "release",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "nrjdalal/shadcn-ui-snippets"
  },
  init = function()
    vim.g.coc_global_extensions = {
      "coc-marketplace",
      "coc-tsserver",
      "coc-eslint",
      "coc-prettier",
      "coc-html",
      "coc-css",
      "coc-json",
      "coc-yaml",
      "coc-markdownlint",
      "coc-sumneko-lua",
      "coc-snippets",
      "@yaegassy/coc-tailwindcss3"
    }
  end,
  config = function()
    local keyset = vim.keymap.set
    function _G.check_back_space()
      local col = vim.fn.col('.') - 1
      return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
    end

    local opts = { silent = true, noremap = true, expr = true, replace_keycodes = true }
    keyset("i", "<Tab>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
    keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
    keyset("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

    keyset("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)")
    keyset("i", "<C-space>", "coc#refresh()", { silent = true, expr = true })

    keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
    keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

    keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
    keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
    keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
    keyset("n", "gr", "<Plug>(coc-references)", { silent = true })
    keyset('n', 'gh', ':call CocAction(\'doHover\')<CR>', { silent = true })

    keyset("n", "<leader>r", "<Plug>(coc-rename)", { silent = true })
    keyset("n", "<leader>f", "<Plug>(coc-format)", { silent = true })

    opts = { silent = true, nowait = true }
    keyset('n', 'ga', "<Plug>(coc-codeaction-line)", opts)
    keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
    keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
    keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
    keyset("n", "<leader>al", "<Plug>(coc-codeaction-line)", opts)
    keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
    keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

    keyset("n", "gt", "<Plug>(coc-translator-p)", opts)

    vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
  end,

}

return M
