local M = {}

if vim.fn.has "nvim-0.9" ~= 1 then
  vim.notify("Please upgrade your Neovim base installation. Lunarvim requires v0.9+", vim.log.levels.WARN)
  vim.wait(5000, function()
    ---@diagnostic disable-next-line: redundant-return-value
    return false
  end)
  vim.cmd "cquit"
end

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"



---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

-- _G.require_clean = require("kide.utils.modules").require_clean
-- _G.require_safe = require("kide.utils.modules").require_safe
-- _G.reload = require("kide.utils.modules").reload

---Get the full path to `$NVIM_RUNTIME_DIR`, the usual is ~/.local/share/nvim
---@return string|nil
function _G.get_runtime_dir()
  local lvim_runtime_dir = os.getenv "NVIM_RUNTIME_DIR"
  if not lvim_runtime_dir then
    -- when nvim is used directly
    return vim.call("stdpath", "data")
  end
  return lvim_runtime_dir
end

---Get the full path to `$NVIM_CONFIG_DIR`, the usual is ~/.config/nvim
---@return string|nil
function _G.get_config_dir()
  local lvim_config_dir = os.getenv "NVIM_CONFIG_DIR"
  if not lvim_config_dir then
    return vim.call("stdpath", "config")
  end
  return lvim_config_dir
end

---Get the full path to `$NVIM_CACHE_DIR`, the usual is ~/.cache/nvim
---@return string|nil
function _G.get_cache_dir()
  local lvim_cache_dir = os.getenv "NVIM_CACHE_DIR"
  if not lvim_cache_dir then
    return vim.call("stdpath", "cache")
  end
  return lvim_cache_dir
end

---Initialize the `&runtimepath` variables and prepare for startup
---@return table
function M:init(base_dir)
  self.runtime_dir = get_runtime_dir()
  self.config_dir = get_config_dir()
  self.cache_dir = get_cache_dir()
  self.pack_dir = join_paths(self.runtime_dir)
  self.lazy_install_dir = join_paths(self.pack_dir, "lazy", "lazy.nvim")

  ---@meta overridden to use LUNARVIM_CACHE_DIR instead, since a lot of plugins call this function internally
  ---NOTE: changes to "data" are currently unstable, see #2507
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.fn.stdpath = function(what)
    if what == "cache" then
      return _G.get_cache_dir()
    end
    return vim.call("stdpath", what)
  end

  ---Get the full path to LunarVim's base directory
  ---@return string
  function _G.get_nvim_base_dir()
    return base_dir
  end

  require("kide.plugin-loader").init {
    package_root = self.pack_dir,
    install_path = self.lazy_install_dir,
  }

  require("kide.config"):init()

  require("kide.plugins.config.mason").bootstrap()

  return self
end

---Update LunarVim
---pulls the latest changes from github and, resets the startup cache
function M:update()
  require("lvim.core.log"):info "Trying to update LunarVim..."

  vim.schedule(function()
    reload("lvim.utils.hooks").run_pre_update()
    local ret = reload("lvim.utils.git").update_base_lvim()
    if ret then
      reload("lvim.utils.hooks").run_post_update()
    end
  end)
end

return M
