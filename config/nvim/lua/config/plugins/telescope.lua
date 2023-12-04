return {
  "nvim-telescope/telescope.nvim",
  cmd = { "Telescope" },
  dependencies = {
    {
      "nvim-telescope/telescope-project.nvim",
      config = function()
        local telescope = require('telescope')
        local actions = require("telescope._extensions.project.actions")
        telescope.load_extension('project')
        vim.api.nvim_create_user_command('TelescopeProjects', function()
          telescope.extensions.project.project {
            attach_mappings = function(_, map)
              map('i', '<C-n>', actions.add_project_cwd)
              return true
            end,
          }
        end, { nargs = 0 })
      end,
      keys = {
        { "<C-e>", "<CMD>TelescopeProjects<CR>", desc = "Projects" },
      }
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end
    },
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-L>"] = actions.cycle_history_next,
            ["<C-H>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
          },
        },
      },
    })
  end,
  keys = {
    { "<C-p>",           "<CMD>Telescope find_files<CR>",  desc = "Find Files" },
    { "<C-f>",           "<CMD>Telescope live_grep<CR>",   desc = "Live Grep" },
    { "<Leader><Space>", "<CMD>Telescope buffers<CR>",     desc = "Buffers" },
    { "<Leader>d",       "<CMD>Telescope diagnostics<CR>", desc = "Diagnostics" },
  },
}
