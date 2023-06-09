local M = {}

function M:init()
  nvim = require("kide.config.defaults")

  -- todo 
  nvim.lsp = require("kide.lsp.config")
end

return M
