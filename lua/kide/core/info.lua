local M = {
  banner = {
    "",
    [[    ____          __         __                              _    __ _          ]],
    [[   / __ ) __  __ / /_ ___   / /_   ____   __  __ _____ ____ | |  / /(_)____ ___ ]],
    [[  / __  |/ / / // __// _ \ / __ \ / __ \ / / / // ___// __ \| | / // // __ `__ \]],
    [[ / /_/ // /_/ // /_ /  __// /_/ // /_/ // /_/ // /__ / / / /| |/ // // / / / / /]],
    [[/_____/ \__, / \__/ \___//_.___/ \____/ \__, / \___//_/ /_/ |___//_//_/ /_/ /_/ ]],
    [[       /____/                          /____/                                   ]],
  },
}

local fmt = string.format
local text = require("kide.interface.text")
local icons = require("kide.icons")

local function str_list(list)
  return #list == 1 and list[1] or fmt("[%s]", table.concat(list, ", "))
end

local function tbl_set_highlight(terms, highlight_group)
  for _, v in pairs(terms) do
    vim.cmd('let m=matchadd("' .. highlight_group .. '", "' .. v .. "[ ,│']\")")
    vim.cmd('let m=matchadd("' .. highlight_group .. '", ", ' .. v .. '")')
  end
end


local function make_formatters_info(ft)
  local null_formatters = require("kide.lsp.null-ls.formatters")
  local registered_formatters = null_formatters.list_registered(ft)
  local supported_formatters = null_formatters.list_supported(ft)
  local section = {
    "Formatters info",
    fmt(
      "* Active: %s%s",
      table.concat(registered_formatters, " " .. icons.ui.BoxChecked .. " , "),
      vim.tbl_count(registered_formatters) > 0 and " " .. icons.ui.BoxChecked .. " " or ""
    ),
    fmt("* Supported: %s", str_list(supported_formatters)),
  }
  return section
end

function M.toggle_popup(ft)
  local formatters_info = make_formatters_info(ft)

  local content_provider = function(popup)
    local content = {}
    for _, section in ipairs {
      M.banner,
      { "" },
      formatters_info,
    } do
      vim.list_extend(content, section)
    end
    return text.align_left(popup, content, 0.5)
  end

  local function set_syntax_hl()
    vim.cmd [[highlight LvimInfoIdentifier gui=bold]]
    vim.cmd [[highlight link LvimInfoHeader Type]]
    vim.fn.matchadd("LvimInfoHeader", "Buffer info")
    vim.fn.matchadd("LvimInfoHeader", "Active client(s)")
    vim.fn.matchadd("LvimInfoHeader", fmt("Overridden %s server(s)", ft))
    vim.fn.matchadd("LvimInfoHeader", "Formatters info")
    vim.fn.matchadd("LvimInfoHeader", "Linters info")
    vim.fn.matchadd("LvimInfoHeader", "Code actions info")
    vim.fn.matchadd("LvimInfoHeader", "Automatic LSP info")
    vim.fn.matchadd("LvimInfoIdentifier", " " .. ft .. "$")
    vim.fn.matchadd("string", "true")
    vim.fn.matchadd("string", "active")
    vim.fn.matchadd("string", icons.ui.BoxChecked)
    vim.fn.matchadd("boolean", "inactive")
    vim.fn.matchadd("error", "false")
    tbl_set_highlight(require("kide.lsp.null-ls.formatters").list_registered(ft), "LvimInfoIdentifier")
    tbl_set_highlight(require("kide.lsp.null-ls.linters").list_registered(ft), "LvimInfoIdentifier")
    tbl_set_highlight(require("kide.lsp.null-ls.code_actions").list_registered(ft), "LvimInfoIdentifier")
  end


  local Popup = require("kide.interface.popup"):new {
    win_opts = { number = false },
    buf_opts = { modifiable = false, filetype = "lspinfo" },
  }
  Popup:display(content_provider)
  set_syntax_hl()
  return Popup
end

return M
