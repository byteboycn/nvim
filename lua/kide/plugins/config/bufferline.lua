local M = {}

require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    -- 使用 nvim 内置lsp
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " " or (e == "warning" and " " or " ")
        s = s .. n .. sym
      end
      return s
    end,
    -- 左侧让出 nvim-tree 的位置
    offsets = {
      {
        filetype = "NvimTree",
        text = function()
          -- return "File Explorer"
          -- git symbolic-ref --short -q HEAD
          -- git --no-pager rev-parse --show-toplevel --absolute-git-dir --abbrev-ref HEAD
          -- git --no-pager rev-parse --short HEAD
          -- local b = vim.fn.trim(vim.fn.system("git symbolic-ref --short -q HEAD"))
          -- if string.match(b, "fatal") then
          -- 	b = ""
          -- else
          -- 	b = "  " .. b
          -- end
          -- return vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t") .. b
          return "File Explorer"
        end,
        padding = 1,
        highlight = "Directory",
        -- text_align = "center"
        text_align = "left",
      },
      {
        filetype = "DiffviewFiles",
        text = function()
          return "DiffviewFilePanel"
        end,
        padding = 1,
        highlight = "Directory",
        -- text_align = "center"
        text_align = "left",
      },
      {
        filetype = "Outline",
        text = " Outline",
        padding = 1,
        highlight = "Directory",
        text_align = "left",
      },
      {
        filetype = "dapui_watches",
        text = "Debug",
        padding = 1,
        highlight = "Directory",
        text_align = "left",
      },
      {
        filetype = "dbui",
        text = "Databases",
        padding = 1,
        highlight = "Directory",
        text_align = "left",
      },
      {
        filetype = "JavaProjects",
        text = " JavaProjects",
        padding = 1,
        highlight = "Directory",
        text_align = "left",
      },
    },
    color_icons = true,
    show_buffer_close_icons = true,
    -- show_buffer_default_icon = true,
    show_close_icon = true,
    show_tab_indicators = true,
    -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
    separator_style = "slant",
    numbers = function(opts)
      return string.format('%s', opts.ordinal)
    end,
    indicator = {
        icon = '▎', -- this should be omitted if indicator style is not 'icon'
        style = 'icon', -- icon | underline | none
    }
  },
})

vim.opt.showtabline = 2


-- Common kill function for bdelete and bwipeout
-- credits: based on bbye and nvim-bufdel
---@param kill_command? string defaults to "bd"
---@param bufnr? number defaults to the current buffer
---@param force? boolean defaults to false
function M.buf_kill(kill_command, bufnr, force)
  kill_command = kill_command or "bd"

  local bo = vim.bo
  local api = vim.api
  local fmt = string.format
  local fnamemodify = vim.fn.fnamemodify

  if bufnr == 0 or bufnr == nil then
    bufnr = api.nvim_get_current_buf()
  end

  local bufname = api.nvim_buf_get_name(bufnr)

  if not force then
    local warning
    if bo[bufnr].modified then
      warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ":t"))
    elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
      warning = fmt([[Terminal %s will be killed]], bufname)
    end
    if warning then
      vim.ui.input({
        prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
      }, function(choice)
        if choice ~= nil and choice:match "ye?s?" then M.buf_kill(kill_command, bufnr, true) end
      end)
      return
    end
  end

  -- Get list of windows IDs with the buffer to close
  local windows = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == bufnr
  end, api.nvim_list_wins())

  if force then
    kill_command = kill_command .. "!"
  end

  -- Get list of active buffers
  local buffers = vim.tbl_filter(function(buf)
    return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
  end, api.nvim_list_bufs())

  -- If there is only one buffer (which has to be the current one), vim will
  -- create a new buffer on :bd.
  -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
  if #buffers > 1 and #windows > 0 then
    for i, v in ipairs(buffers) do
      if v == bufnr then
        local prev_buf_idx = i == 1 and #buffers or (i - 1)
        local prev_buffer = buffers[prev_buf_idx]
        for _, win in ipairs(windows) do
          api.nvim_win_set_buf(win, prev_buffer)
        end
      end
    end
  end

  -- Check if buffer still exists, to ensure the target buffer wasn't killed
  -- due to options like bufhidden=wipe.
  if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
    vim.cmd(string.format("%s %d", kill_command, bufnr))
  end
end

return M

