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
local lsp_utils = require("kide.lsp.utils")

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

local function make_client_info(client)
  if client.name == "null-ls" then
    return
  end
  local client_enabled_caps = lsp_utils.get_client_capabilities(client.id)
  local name = client.name
  local id = client.id
  local filetypes = lsp_utils.get_supported_filetypes(name)
  local attached_buffers_list = str_list(vim.lsp.get_buffers_by_client_id(client.id))
  local client_info = {
    fmt("* name:                      %s", name),
    fmt("* id:                        %s", tostring(id)),
    fmt("* supported filetype(s):     %s", str_list(filetypes)),
    fmt("* attached buffers:          %s", tostring(attached_buffers_list)),
    fmt("* root_dir pattern:          %s", tostring(attached_buffers_list)),
  }
  if not vim.tbl_isempty(client_enabled_caps) then
    local caps_text = "* capabilities:              "
    local caps_text_len = caps_text:len()
    local enabled_caps = text.format_table(client_enabled_caps, 3, " | ")
    enabled_caps = text.shift_right(enabled_caps, caps_text_len)
    enabled_caps[1] = fmt("%s%s", caps_text, enabled_caps[1]:sub(caps_text_len + 1))
    vim.list_extend(client_info, enabled_caps)
  end

  return client_info
end

function M.toggle_popup(ft)
  local clients = vim.lsp.get_active_clients()
  local client_names = {}
  local formatters_info = make_formatters_info(ft)
  local bufnr = vim.api.nvim_get_current_buf()
  local ts_active_buffers = vim.tbl_keys(vim.treesitter.highlighter.active)
  local is_treesitter_active = function()
    local status = "inactive"
    if vim.tbl_contains(ts_active_buffers, bufnr) then
      status = "active"
    end
    return status
  end
  local header = {
    "Buffer info",
    fmt("* filetype:                %s", ft),
    fmt("* bufnr:                   %s", bufnr),
    fmt("* treesitter status:       %s", is_treesitter_active()),
  }

  local lsp_info = {
    "Active client(s)",
  }

  for _, client in pairs(clients) do
    local client_info = make_client_info(client)
    if client_info then
      vim.list_extend(lsp_info, client_info)
    end
    table.insert(client_names, client.name)
  end

  local content_provider = function(popup)
    local content = {}
    for _, section in ipairs({
      M.banner,
      { "" },
      { "" },
      header,
      { "" },
      lsp_info,
      { "" },
      formatters_info,
    }) do
      vim.list_extend(content, section)
    end
    return text.align_left(popup, content, 0.5)
  end

  local function set_syntax_hl()
    vim.cmd([[highlight LvimInfoIdentifier gui=bold]])
    vim.cmd([[highlight link LvimInfoHeader Type]])
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

  local Popup = require("kide.interface.popup"):new({
    win_opts = { number = false },
    buf_opts = { modifiable = false, filetype = "lspinfo" },
  })
  Popup:display(content_provider)
  set_syntax_hl()
  return Popup
end

return M
