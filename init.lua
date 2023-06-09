-- math.randomseed(os.time())
-- the base_dir usual is ~/.config/nvim
local base_dir = vim.env.NVIM_BASE_DIR
  or (function()
    local init_path = debug.getinfo(1, "S").source
    return init_path:sub(2):match("(.*[/\\])"):sub(1, -2)
  end)()

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:prepend(base_dir)
end

require("kide.core")

require("kide.bootstrap"):init(base_dir)

local plugins = require("kide.plugins")
require("kide.plugin-loader").load { plugins, nvim.plugins }


vim.schedule(function()
  require("kide.core.keybindings").setup()
end)

local commands = require "kide.plugins.config.commands"
commands.load(commands.defaults)
