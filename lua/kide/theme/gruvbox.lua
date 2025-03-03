local M = {}
local colors = {
  white = "#ebdbb2",
  darker_black = "#232323",
  black = "#282828",
  black2 = "#2e2e2e",
  black3 = "#313131",
  gray = "#928374",
  red = "#fb4934",
  green = "#b8bb26",
  yellow = "#fabd2f",
  yellow2 = "#d79921",
  blue = "#83a598",
  blue2 = "#458588",
}
M.colors = colors
local flat_telescope = {
  TelescopeBorder = {
    fg = colors.darker_black,
    bg = colors.darker_black,
  },

  TelescopePromptTitle = {
    fg = colors.black,
    bg = colors.red,
  },
  TelescopePromptPrefix = {
    fg = colors.red,
    bg = colors.darker_black,
  },
  TelescopePromptBorder = {
    fg = colors.darker_black,
    bg = colors.darker_black,
  },
  TelescopePromptNormal = {
    fg = colors.white,
    bg = colors.darker_black,
  },

  TelescopeResultsTitle = {
    fg = colors.black2,
    bg = colors.black2,
  },
  TelescopeResultsBorder = {
    fg = colors.black2,
    bg = colors.black2,
  },
  TelescopeResultsNormal = {
    fg = colors.white,
    bg = colors.black2,
  },

  TelescopeNormal = { bg = colors.darker_black },

  TelescopePreviewTitle = {
    fg = colors.black3,
    bg = colors.green,
  },
  TelescopePreviewBorder = {
    fg = colors.black3,
    bg = colors.black3,
  },
  TelescopePreviewNormal = {
    fg = colors.white,
    bg = colors.black3,
  },

  TelescopeSelection = { bg = colors.black2, fg = colors.yellow },
}

M.load_telescope_highlights = function()
  M.load_highlights(flat_telescope)
end
M.load_highlights = function(hl_groups)
  for hl, col in pairs(hl_groups) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

function M.setup()
  require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {
      NormalFloat = {
        bg = "#313131",
      },
      Pmenu = {
        bg = "#2e2e2e",
      },
    },
    dim_inactive = false,
    transparent_mode = false,
  })
  -- dark or light
  vim.opt.background = "dark"
  vim.cmd([[colorscheme gruvbox]])
end

return M
