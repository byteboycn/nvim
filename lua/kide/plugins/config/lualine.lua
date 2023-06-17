local window_width_limit = 100

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end
local colors = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  purple = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > window_width_limit
  end,
  -- check_git_workspace = function()
  --   local filepath = vim.fn.expand "%:p:h"
  --   local gitdir = vim.fn.finddir(".git", filepath .. ";")
  --   return gitdir and #gitdir > 0 and #gitdir < #filepath
  -- end,
}
local components = {
  progress = {
    "progress",
    fmt = function()
      return "%P/%L"
    end,
    color = {},
  },
  location = { "location" },
  branch = {
    "b:gitsigns_head",
    icon = nvim.icons.git.Branch,
    color = { gui = "bold" },
  },
  diff = {
    "diff",
    source = diff_source,
    symbols = {
      added = nvim.icons.git.LineAdded .. " ",
      modified = nvim.icons.git.LineModified .. " ",
      removed = nvim.icons.git.LineRemoved .. " ",
    },
    padding = { left = 2, right = 1 },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    cond = nil,
  },
  filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return nvim.icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  encoding = { "encoding" },
  mode = { "mode" },
  lsp = {
    function()
      local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
      if #buf_clients == 0 then
        return "LSP Inactive"
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end

        if client.name == "copilot" then
          copilot_active = true
        end
      end

      -- add formatter
      local formatters = require "kide.lsp.null-ls.formatters"
      local supported_formatters = formatters.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      local linters = require "kide.lsp.null-ls.linters"
      local supported_linters = linters.list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_linters)

      local unique_client_names = vim.fn.uniq(buf_client_names)

      local language_servers = "[" .. table.concat(unique_client_names, ", ") .. "]"

      if copilot_active then
        language_servers = language_servers .. "%#SLCopilot#" .. " " .. nvim.icons.git.Octoface .. "%*"
      end

      return language_servers
    end,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = nvim.icons.diagnostics.BoldError .. " ",
      warn = nvim.icons.diagnostics.BoldWarning .. " ",
      info = nvim.icons.diagnostics.BoldInformation .. " ",
      hint = nvim.icons.diagnostics.BoldHint .. " ",
    },
    -- cond = conditions.hide_in_width,
  },
  filename = { "filename" },
}

local config = {
  options = {
    icons_enabled = true,
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha" },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { components.mode },
    lualine_b = { components.branch },
    lualine_c = { components.diff },
    -- lualine_c = {
    --   {
    --     function()
    --       local names = {}
    --       for _, server in pairs(vim.lsp.buf_get_clients(0)) do
    --         table.insert(names, server.name)
    --       end
    --       if vim.tbl_isempty(names) then
    --         return " [No LSP]"
    --       else
    --         return " [" .. table.concat(names, " ") .. "]"
    --       end
    --     end,
    --   },
    --   "filename",
    --   "navic",
    -- },
    lualine_x = { components.diagnostics, components.lsp, components.spaces, components.filetype },
    lualine_y = { components.location },
    lualine_z = { components.progress },
  },
  inactive_sections = {
    lualine_a = {},
    -- lualine_b = {function() return require('lsp-status').status() end},
    lualine_b = {},
    lualine_c = { components.filename },
    lualine_x = { components.location },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "quickfix", "toggleterm", "fugitive", "symbols-outline", "nvim-dap-ui" },
}

local dap = {}
dap.sections = {
  lualine_a = {
    { "filename", file_status = false },
  },
}
dap.filetypes = {
  "dap-terminal",
  "dapui_console",
}
table.insert(config.extensions, dap)

-- NvimTree
local nerdtree = require("lualine.extensions.nerdtree")

local nvim_tree = {}
nvim_tree.sections = vim.deepcopy(nerdtree.sections)
nvim_tree.sections.lualine_b = { "branch" }
nvim_tree.filetypes = {
  "NvimTree",
}
table.insert(config.extensions, nvim_tree)

-- nvim-sqls extensions
-- local db_connection_value = "default"
-- local db_database_value = "default"
-- require("sqls.events").add_subscriber("connection_choice", function(event)
--   local cs = vim.split(event.choice, " ")
--   db_connection_value = cs[3]
--   local db = vim.split(cs[4], "/")
--   if db[2] and db_database_value == "default" then
--     db_database_value = db[2]
--   end
-- end)
-- require("sqls.events").add_subscriber("database_choice", function(event)
--   db_database_value = event.choice
-- end)
-- local function db_info()
--   return db_connection_value .. "->" .. db_database_value
-- end
--
-- local sqls = {}
-- sqls.sections = vim.deepcopy(config.sections)
-- table.insert(sqls.sections.lualine_c, db_info)
-- sqls.filetypes = {
--   "sql",
-- }
-- table.insert(config.extensions, sqls)

-- DiffviewFilePanel
local diffview = {}
diffview.sections = {
  lualine_a = {
    { "filename", file_status = false },
  },
}
diffview.filetypes = {
  "DiffviewFiles",
}
table.insert(config.extensions, diffview)

-- db-ui
local dbui = {}
dbui.sections = {
  lualine_a = {
    { "filename", file_status = false },
  },
}
dbui.filetypes = {
  "dbui",
  "dbout",
}
table.insert(config.extensions, dbui)

-- JavaProjects
local java_projects = {}
java_projects.sections = {
  lualine_a = {
    { "filename", file_status = false },
  },
}
java_projects.filetypes = {
  "JavaProjects",
}
table.insert(config.extensions, java_projects)
require("lualine").setup(config)
