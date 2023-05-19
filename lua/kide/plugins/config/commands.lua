    end,
  },
  {
    name = "LvimVersion",
    fn = function()
      print(require("lvim.utils.git").get_lvim_version())
    end,
  },
  {
    name = "LvimOpenlog",
    fn = function()
      vim.fn.execute("edit " .. require("lvim.core.log").get_path())
    end,
  },
}

function M.load(collection)
  local common_opts = { force = true }
  for _, cmd in pairs(collection) do
    local opts = vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
    vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
  end
end

return M
