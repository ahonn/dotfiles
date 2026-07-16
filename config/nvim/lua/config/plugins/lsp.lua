local servers = {
  biome = {},
  eslint = {},
  lua_ls = {
    settings = {
      Lua = {
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
      },
    },
  },
  pest_ls = {},
  prismals = {},
}

local function setup_servers()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  for name, config in pairs(servers) do
    config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

    vim.lsp.config(name, config)
    vim.lsp.enable(name)
  end
end

local function enable_inlay_hints()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
      end
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "pest-parser/pest.vim",
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "biome",
          "eslint-lsp",
          "eslint_d",
          "lua-language-server",
          "pest-language-server",
          "prettier",
          "prisma-language-server",
          "rust-analyzer",
        },
      })

      setup_servers()
      enable_inlay_hints()
    end,
    keys = {
      { "gh",        "<CMD>lua vim.lsp.buf.hover()<CR>",                            desc = "Show hover information" },
      { "gr",        "<CMD>lua require('telescope.builtin').lsp_references()<CR>",      desc = "Find references" },
      { "gd",        "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>",     desc = "Find definitions" },
      { "gi",        "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>", desc = "Go to implementation" },
      {
        "ga",
        "<CMD>lua vim.lsp.buf.code_action()<CR>",
        mode = { "n", "v" },
        desc = "Code action",
      },
      { "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>",                               desc = "Rename symbol" },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        server = {
          cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                targetDir = true,
              },
              check = {
                command = "check",
              },
            },
          },
        },
      }
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "BufRead",
    opts = {},
  },
}
