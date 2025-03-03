local M = {}

-- local symbol_map = require("kide.lsp.lsp_ui").symbol_map
local icons = nvim.icons.kind
M.config = function()
  nvim.builtin.nvim_navic = {
    active = true,
    on_config_done = nil,
    winbar_filetype_exclude = {
      "help",
      "startify",
      "dashboard",
      "lazy",
      "neo-tree",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "alpha",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "Jaq",
      "harpoon",
      "dap-repl",
      "dap-terminal",
      "dapui_console",
      "dapui_hover",
      "lab",
      "notify",
      "noice",
      "neotest-summary",
      "",
    },
    options = {
      icons = {
        Array = icons.Array .. " ",
        Boolean = icons.Boolean .. " ",
        Class = icons.Class .. " ",
        Color = icons.Color .. " ",
        Constant = icons.Constant .. " ",
        Constructor = icons.Constructor .. " ",
        Enum = icons.Enum .. " ",
        EnumMember = icons.EnumMember .. " ",
        Event = icons.Event .. " ",
        Field = icons.Field .. " ",
        File = icons.File .. " ",
        Folder = icons.Folder .. " ",
        Function = icons.Function .. " ",
        Interface = icons.Interface .. " ",
        Key = icons.Key .. " ",
        Keyword = icons.Keyword .. " ",
        Method = icons.Method .. " ",
        Module = icons.Module .. " ",
        Namespace = icons.Namespace .. " ",
        Null = icons.Null .. " ",
        Number = icons.Number .. " ",
        Object = icons.Object .. " ",
        Operator = icons.Operator .. " ",
        Package = icons.Package .. " ",
        Property = icons.Property .. " ",
        Reference = icons.Reference .. " ",
        Snippet = icons.Snippet .. " ",
        String = icons.String .. " ",
        Struct = icons.Struct .. " ",
        Text = icons.Text .. " ",
        TypeParameter = icons.TypeParameter .. " ",
        Unit = icons.Unit .. " ",
        Value = icons.Value .. " ",
        Variable = icons.Variable .. " ",
      },
      highlight = true,
      separator = " " .. nvim.icons.ui.ChevronRight .. " ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    },
  }
end
-- local opt = {
--   icons = {
--     File = symbol_map.File.icon .. " ",
--     Module = symbol_map.Module.icon .. " ",
--     Namespace = symbol_map.Namespace.icon .. " ",
--     Package = symbol_map.Package.icon .. " ",
--     Class = symbol_map.Class.icon .. " ",
--     Method = symbol_map.Method.icon .. " ",
--     Property = symbol_map.Property.icon .. " ",
--     Field = symbol_map.Field.icon .. " ",
--     Constructor = symbol_map.Constructor.icon .. " ",
--     Enum = symbol_map.Enum.icon .. "",
--     Interface = symbol_map.Interface.icon .. "",
--     Function = symbol_map.Function.icon .. " ",
--     Variable = symbol_map.Variable.icon .. " ",
--     Constant = symbol_map.Constant.icon .. " ",
--     String = symbol_map.String.icon .. " ",
--     Number = symbol_map.Number.icon .. " ",
--     Boolean = symbol_map.Boolean.icon .. " ",
--     Array = symbol_map.Array.icon .. " ",
--     Object = symbol_map.Object.icon .. " ",
--     Key = symbol_map.Key.icon .. " ",
--     Null = symbol_map.Null.icon .. " ",
--     EnumMember = symbol_map.EnumMember.icon .. " ",
--     Struct = symbol_map.Struct.icon .. " ",
--     Event = symbol_map.Event.icon .. " ",
--     Operator = symbol_map.Operator.icon .. " ",
--     TypeParameter = symbol_map.TypeParameter.icon .. " ",
--   },
--   -- highlight = false,
--   separator = "  ",
--   -- depth_limit = 0,
--   -- depth_limit_indicator = "..",
-- }

M.setup = function()
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  M.create_winbar()
  navic.setup(nvim.builtin.nvim_navic.options)
end

M.get_filename = function()
  local filename = vim.fn.expand "%:t"
  local extension = vim.fn.expand "%:e"
  local f = require "kide.utils.functions"

  if not f.isempty(filename) then
    local file_icon, hl_group
    local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
    if nvim.use_icons and devicons_ok then
      file_icon, hl_group = devicons.get_icon(filename, extension, { default = true })

      if f.isempty(file_icon) then
        file_icon = nvim.icons.kind.File
      end
    else
      file_icon = ""
      hl_group = "Normal"
    end

    local buf_ft = vim.bo.filetype

    if buf_ft == "dapui_breakpoints" then
      file_icon = nvim.icons.ui.Bug
    end

    if buf_ft == "dapui_stacks" then
      file_icon = nvim.icons.ui.Stacks
    end

    if buf_ft == "dapui_scopes" then
      file_icon = nvim.icons.ui.Scopes
    end

    if buf_ft == "dapui_watches" then
      file_icon = nvim.icons.ui.Watches
    end

    -- if buf_ft == "dapui_console" then
    --   file_icon = lvim.icons.ui.DebugConsole
    -- end

    local navic_text = vim.api.nvim_get_hl_by_name("Normal", true)
    vim.api.nvim_set_hl(0, "Winbar", { fg = navic_text.foreground })

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
  end
end

local excludes = function()
  return vim.tbl_contains(nvim.builtin.nvim_navic.winbar_filetype_exclude or {}, vim.bo.filetype)
end
local get_gps = function()
  local status_gps_ok, gps = pcall(require, "nvim-navic")
  if not status_gps_ok then
    return ""
  end

  local status_ok, gps_location = pcall(gps.get_location, {})
  if not status_ok then
    return ""
  end

  if not gps.is_available() or gps_location == "error" then
    return ""
  end

  if not require("kide.utils.functions").isempty(gps_location) then
    return "%#NavicSeparator#" .. nvim.icons.ui.ChevronRight .. "%* " .. gps_location
  else
    return ""
  end
end

M.get_winbar = function()
  if excludes() then
    return
  end
  local f = require "kide.utils.functions"
  local value = M.get_filename()

  local gps_added = false
  if not f.isempty(value) then
    local gps_value = get_gps()
    value = value .. " " .. gps_value
    if not f.isempty(gps_value) then
      gps_added = true
    end
  end

  if not f.isempty(value) and f.get_buf_option "mod" then
    -- TODO: replace with circle
    local mod = "%#LspCodeLens#" .. nvim.icons.ui.Circle .. "%*"
    if gps_added then
      value = value .. " " .. mod
    else
      value = value .. mod
    end
  end

  local num_tabs = #vim.api.nvim_list_tabpages()

  if num_tabs > 1 and not f.isempty(value) then
    local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))
    value = value .. "%=" .. tabpage_number .. "/" .. tostring(num_tabs)
  end

  local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
  if not status_ok then
    return
  end
end

M.create_winbar = function()
  vim.api.nvim_create_augroup("_winbar", {})
  vim.api.nvim_create_autocmd({
    "CursorHoldI",
    "CursorHold",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
    "TabClosed",
    "TabEnter",
  }, {
    group = "_winbar",
    callback = function()
      if nvim.builtin.nvim_navic.active then
        local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
        if not status_ok then
          -- TODO:
          require("kide.plugins.config.nvim-navic").get_winbar()
        end
      end
    end,
  })
end
return M
