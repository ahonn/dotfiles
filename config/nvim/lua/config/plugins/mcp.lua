local M = {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup(
        {
          extensions = {
            codecompanion = {
              -- Show the mcp tool result in the chat buffer
              show_result_in_chat = true,
              make_vars = true,         -- make chat #variables from MCP server resources
              make_slash_commands = true, -- make /slash_commands from MCP server prompts
            },
          }
        }
      )
    end,
  }
}

return M
