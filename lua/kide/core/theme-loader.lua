local Log = require "kide.core.log"

local M = {}

-- todo unused
-- M.config = function()
--   nvim.builtin.theme = {
--     name = "lunar",
--     lunar = {
--       options = { -- currently unused
--       },
--     },
--   }
-- end

M.setup = function()
  -- avoid running in headless mode since it's harder to detect failures
  if #vim.api.nvim_list_uis() == 0 then
    Log:debug "headless mode detected, skipping running setup for lualine"
    return
  end


  -- 设置主题的自定义配置，加载位置：kide.theme.{nvim.colorscheme}.options
    local status_ok, plugin = pcall(require, nvim.colorscheme)
    if status_ok then
      local opt_status_ok, plugin_options = pcall(require, "kide.theme." .. nvim.colorscheme)
      if opt_status_ok then
        pcall(function()
          plugin.setup(plugin_options)
        end)
      end
    end

  -- ref: https://github.com/neovim/neovim/issues/18201#issuecomment-1104754564
  local colors = vim.api.nvim_get_runtime_file(("colors/%s.*"):format(nvim.colorscheme), false)
  if #colors == 0 then
    Log:debug(string.format("Could not find '%s' colorscheme", nvim.colorscheme))
    return
  end

  vim.g.colors_name = nvim.colorscheme
  vim.cmd("colorscheme " .. nvim.colorscheme)

  -- if package.loaded.lualine then
  --   require("lvim.core.lualine").setup()
  -- end
  -- if package.loaded.lir then
  --   require("lvim.core.lir").icon_setup()
  -- end
end

return M
