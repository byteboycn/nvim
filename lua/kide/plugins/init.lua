require("lazy_bootstrap")
require("kide.plugins.lazy-nvim")
vim.schedule(function()
  require("kide.core.keybindings").setup()
end)

local commands = require "kide.plugins.config.commands"
commands.load(commands.defaults)
