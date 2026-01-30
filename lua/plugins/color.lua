return {
  "catppuccin/nvim",
  name = "catppuccin",
  config = function()
    require("catppuccin").setup({
      flavour = "auto",
      background = {
	      dark = "mocha",
	      light = "latte",
      },
      show_end_end_of_buffer = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        notify = true,
        fzf = true,
        lsp_saga = true,
        neotest = true,
        copilot_vim = true,
        nvim_surround = true,
        telescope = true,
        lsp_trouble = true,
        which_key = true,
      },
      color_overrides = {
        mocha = { -- custom
          rosewater = "#ffc6be",
          flamingo = "#fb4934",
          pink = "#ff75a0",
          mauve = "#f2594b",
          red = "#f2594b",
          maroon = "#fe8019",
          peach = "#FFAD7D",
          yellow = "#e9b143",
          green = "#b0b846",
          teal = "#8bba7f",
          sky = "#7daea3",
          sapphire = "#689d6a",
          blue = "#80aa9e",
          lavender = "#e2cca9",
          text = "#e2cca9",
          subtext1 = "#e2cca9",
          subtext0 = "#e2cca9",
          overlay2 = "#8C7A58",
          overlay1 = "#735F3F",
          overlay0 = "#806234",
          surface2 = "#665c54",
          surface1 = "#3c3836",
          surface0 = "#32302f",
          base = "#282828",
          mantle = "#1d2021",
          crust = "#1b1b1b",
        },
      },
      custom_highlights = function(colors)
        local u = require("catppuccin.utils.colors")
        return {
          CursorLineNr = { bg = u.blend(colors.overlay0, colors.base, 0.75), style = { "bold" } },
          CursorLine = { bg = u.blend(colors.overlay0, colors.base, 0.45) },
          LspReferenceText = { bg = colors.surface2 },
          LspReferenceWrite = { bg = colors.surface2 },
          LspReferenceRead = { bg = colors.surface2 },

          -- make it less of a colored mess
          Function = { link = "Normal" },
          Operator = { link = "Normal" },
          Identifier = { link = "Normal" },
        }
      end,
    })

    vim.cmd("colorscheme catppuccin")
  end,
}
