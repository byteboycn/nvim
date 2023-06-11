local M = {}

function M:init()
  nvim = require("kide.config.defaults")

  local builtins = require("kide.core.builtins")
  builtins.config {}
  -- todo 
  local autocmds = require "kide.core.autocmds"
  autocmds.load_defaults()

  nvim.lsp = require("kide.lsp.config")
end

return M
