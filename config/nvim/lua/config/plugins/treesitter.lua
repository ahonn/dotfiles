local parsers = {
  "beancount",
  "css",
  "ecma",
  "graphql",
  "html",
  "html_tags",
  "javascript",
  "json",
  "jsx",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "prisma",
  "query",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local filetypes = {
  "beancount",
  "css",
  "graphql",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "nix",
  "prisma",
  "query",
  "rust",
  "toml",
  "typescript",
  "typescriptreact",
  "vim",
  "yaml",
}

local function map_textobject(modes, lhs, module, method, query)
  vim.keymap.set(modes, lhs, function()
    require("nvim-treesitter-textobjects." .. module)[method](query, "textobjects")
  end)
end

local function setup_textobjects()
  require("nvim-treesitter-textobjects").setup({
    select = { lookahead = true },
    move = { set_jumps = true },
  })

  map_textobject({ "x", "o" }, "af", "select", "select_textobject", "@function.outer")
  map_textobject({ "x", "o" }, "if", "select", "select_textobject", "@function.inner")
  map_textobject({ "x", "o" }, "ac", "select", "select_textobject", "@class.outer")
  map_textobject({ "x", "o" }, "ic", "select", "select_textobject", "@class.inner")
  map_textobject({ "x", "o" }, "aa", "select", "select_textobject", "@parameter.inner")
  map_textobject({ "x", "o" }, "ia", "select", "select_textobject", "@parameter.outer")
  map_textobject({ "x", "o" }, "ab", "select", "select_textobject", "@block.outer")
  map_textobject({ "x", "o" }, "ib", "select", "select_textobject", "@block.inner")
  map_textobject("n", "ma", "swap", "swap_next", "@parameter.inner")
  map_textobject("n", "mA", "swap", "swap_previous", "@parameter.inner")
  map_textobject({ "n", "x", "o" }, "]f", "move", "goto_next_start", "@function.outer")
  map_textobject({ "n", "x", "o" }, "]F", "move", "goto_next_end", "@function.outer")
  map_textobject({ "n", "x", "o" }, "[f", "move", "goto_previous_start", "@function.outer")
  map_textobject({ "n", "x", "o" }, "[F", "move", "goto_previous_end", "@function.outer")
end

local function setup_shared_plugins()
  require("nvim-ts-autotag").setup()
  require("ts_context_commentstring").setup({ enable_autocmd = true })
end

local function setup_treesitter()
  require("nvim-treesitter").install(parsers)
  setup_textobjects()
  setup_shared_plugins()

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return {
  {
    url = "https://github.com/neovim-treesitter/nvim-treesitter.git",
    name = "neovim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    config = setup_treesitter,
  },
  {
    "Wansmer/treesj",
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
    keys = {
      { "<Leader>j", "<CMD>lua require('treesj').toggle()<CR>", desc = "Toggle TreeSJ" },
    },
  },
}
