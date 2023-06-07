local M = {}

function M:init()
  bvim = {}

  -- todo 
  bvim.lsp = require("kide.lsp.config")
end

return M
