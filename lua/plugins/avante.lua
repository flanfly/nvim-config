local provider = "claude"
if os.getenv("AVANTE_OPENAI_API_KEY") then
  provider = "openai"
elseif os.getenv("OPENAI_API_KEY") then
  provider = "openai"
end

return {
  "yetone/avante.nvim",
  build = "make",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    selection = {
      hint_display = "none",
    },
    instructions_file = "avante.md",
    provider = provider,
    providers = {
      openai = {
        model = "gpt-4o-mini",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
          top_p = 1,
          frequency_penalty = 0,
          presence_penalty = 0,
        },
      },
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
    selector = {
      exclude_auto_select = { "NvimTree" },
    },
    mappings = {
      sidebar = {
        close_from_input = { normal = "<Esc>", insert = "<C-d>" }
      }
    },
    web_search_engine = {
      provider = "google",
      proxy = nil,
    },
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    -- Using function prevents requiring mcphub before it's loaded
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
  },
  keys = {
    {
      "<leader>aa",
      function()
        local tree_ext = require("avante.extensions.nvim_tree")
        tree_ext.add_file()
      end,
      desc = "Select file in NvimTree",
      ft = "NvimTree",
    },
    {
      "<leader>ax",
      function()
        local tree_ext = require("avante.extensions.nvim_tree")
        tree_ext.remove_file()
      end,
      desc = "Deselect file in NvimTree",
      ft = "NvimTree",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "stevearc/dressing.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
    "ravitemer/mcphub.nvim",
  },
}
