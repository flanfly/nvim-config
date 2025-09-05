return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "bundled_build.lua",
  opts = {
    use_bundled_binary = true,
    config = vim.fn.expand("~/.config/nvim/lua/plugins/mcp-hub-servers.json"),
    extensions = {
      avante = {
        make_slash_commands = true,
      },
    },
    native_servers = {},
  }
}
