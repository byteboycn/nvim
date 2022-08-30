local lsp_ui = require("kide.lsp.lsp_ui")
local symbols_map = lsp_ui.symbol_map
-- init.lua
require("symbols-outline").setup({
  highlight_hovered_item = false,
  show_guides = true,
  auto_preview = false,
  position = "right",
  relative_width = true,
  width = 25,
  auto_close = false,
  show_numbers = false,
  show_relative_numbers = false,
  show_symbol_details = true,
  preview_bg_highlight = "Pmenu",
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = { "<Esc>", "q" },
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    toggle_preview = "K",
    rename_symbol = "r",
    code_actions = "a",
  },
  lsp_blacklist = {},
  symbol_blacklist = {},
  symbols = {
    File = symbols_map.File,
    Module = symbols_map.Module,
    Namespace = symbols_map.Namespace,
    Package = symbols_map.Package,
    Class = symbols_map.Class,
    Method = symbols_map.Method,
    Property = symbols_map.Property,
    Field = symbols_map.Field,
    Constructor = symbols_map.Constructor,
    Enum = symbols_map.Enum,
    Interface = symbols_map.Interface,
    Function = symbols_map.Function,
    Variable = symbols_map.Variable,
    Constant = symbols_map.Constant,
    String = symbols_map.String,
    Number = symbols_map.Number,
    Boolean = symbols_map.Boolean,
    Array = symbols_map.Array,
    Object = symbols_map.Object,
    Key = symbols_map.Key,
    Null = symbols_map.Null,
    EnumMember = symbols_map.EnumMember,
    Struct = symbols_map.Struct,
    Event = symbols_map.Event,
    Operator = symbols_map.Operator,
    TypeParameter = symbols_map.TypeParameter,
    Component = symbols_map.Component,
    Fragment = symbols_map.Fragment,
  },
})
