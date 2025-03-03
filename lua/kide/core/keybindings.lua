-- vim.g.mapleader = ";"
-- vim.g.maplocalleader = ";"

local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }
local keymap = vim.keymap.set
local M = {}

M.setup = function()
  -- Esc
  -- map("i", "jk", "<C-\\><C-N>", opt)
  -- n 模式下复制内容到系统剪切板
  map("n", "<Leader>yy", '"+yy', opt)
  -- v 模式下复制内容到系统剪切板
  map("v", "<Leader>yy", '"+yy', opt)
  -- n 模式下粘贴系统剪切板的内容
  map("n", "<Leader>v", '"+p', opt)
  -- 取消搜索高亮显示
  map("n", "<Leader><CR>", ":nohlsearch<CR>", opt)
  map("n", "<Esc>", ":nohlsearch<CR>", opt)
  -- 移动焦点到不同窗口
  keymap("n", "<C-h>", "<C-w>h", opt)
  keymap("n", "<C-j>", "<C-w>j", opt)
  keymap("n", "<C-k>", "<C-w>k", opt)
  keymap("n", "<C-l>", "<C-w>l", opt)

  vim.api.nvim_create_user_command("BufferCloseOther", function()
    require("kide.core.utils").close_other_bufline()
  end, {})
  -- map("n", "<Leader>s", ":w<CR>", opt)
  -- map("n", "<Leader>w", ":bd<CR>", opt)
  map("n", "<Leader>W", ":%bd<CR>", opt)
  map("n", "<Leader>q", ":q<CR>", opt)
  -- buffer
  map("n", "<leader>n", ":BufferLineCycleNext <CR>", opt)
  map("n", "<leader>p", ":BufferLineCyclePrev <CR>", opt)
  -- window
  map("n", "<A-[>", ":vertical resize +5 <CR>", opt)
  map("n", "<A-]>", ":vertical resize -5  <CR>", opt)

  -- " 退出 terminal 模式
  map("t", "<Esc>", "<C-\\><C-N>", opt)
  -- map("t", "jk", "<C-\\><C-N>", opt)

  -- ToggleTerm
  map("n", "<F12>", ":ToggleTerm<CR>", opt)
  map("t", "<F12>", "<C-\\><C-N>:ToggleTerm<CR>", opt)
  map("n", "<leader>tt", ":ToggleTerm<CR>", opt)
  map("v", "<leader>tt", ":ToggleTermSendVisualSelection<CR>", opt)
  map("t", "tt", "<C-\\><C-N>:ToggleTerm<CR>", opt)
  map("n", "<leader>tv", ":ToggleTerm dir=%:p:h size=100 direction=vertical<CR>", opt)
  map("n", "<leader>th", ":ToggleTerm dir=%:p:h size=30 direction=horizontal<CR>", opt)
  -- stop and close  
  map("n", "<C-t>", ":bd!<CR>", opt)


  -- symbols-outline.nvim
  map("n", "<space>o", ":<C-u>SymbolsOutline<CR>", opt)

  -- Telescope
  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opt)
  keymap("v", "<leader>ff", function()
    local tb = require("telescope.builtin")
    local text = require("kide.core.utils").get_visual_selection()
    tb.find_files({ default_text = text })
  end, opt)
  map("n", "<C-p>", "<cmd>Telescope find_files<cr>", opt)
  map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opt)
  keymap("v", "<leader>fg", function()
    local tb = require("telescope.builtin")
    local text = require("kide.core.utils").get_visual_selection()
    tb.live_grep({ default_text = text })
  end, opt)
  map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opt)
  map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opt)

  -- translate
  map("n", "<leader>tz", ":Translate ZH -source=EN -parse_after=window -output=floating<cr>", opt)
  map("v", "<leader>tz", ":Translate ZH -source=EN -parse_after=window -output=floating<cr>", opt)
  map("n", "<leader>te", ":Translate EN -source=ZH -parse_after=window -output=floating<cr>", opt)
  map("v", "<leader>te", ":Translate EN -source=ZH -parse_after=window -output=floating<cr>", opt)

  -- camel_case
  require("kide.core.utils").camel_case_init()

  -- nvim-dap
  keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", opt)
  keymap("n", "<F6>", ":lua require'dap'.step_over()<CR>", opt)
  keymap("n", "<F7>", ":lua require'dap'.step_into()<CR>", opt)
  keymap("n", "<F8>", ":lua require'dap'.step_out()<CR>", opt)
  -- keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", opt)
  -- keymap("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opt)
  -- keymap("n", "<leader>dp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", opt)
  -- keymap("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", opt)
  -- keymap("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", opt)

  -- nvim-dap-ui
  -- keymap("n", "<leader>ds", ':lua require("dapui").float_element(vim.Nil, { enter = true}) <CR>', opt)

  -- bufferline.nvim
  keymap("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opt)
  keymap("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opt)
  keymap("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opt)
  keymap("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opt)
  keymap("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opt)
  keymap("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opt)
  keymap("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opt)
  keymap("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opt)
  keymap("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opt)

  -- nvim-spectre
  map("n", "<leader>S", "<cmd>lua require('spectre').open()<CR>", opt)
  -- search current word
  map("n", "<leader>fr", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", opt)
  map("v", "<leader>fr", "<esc>:lua require('spectre').open_visual()<CR>", opt)

  -- ToggleTask
  map("n", "<leader>ts", "<cmd>Telescope toggletasks spawn<cr>", opt)

  -- nvimTree
  map("n", "<leader>e", ":NvimTreeToggle<CR>", opt)

  -- 快速滚动
  map("n", "J", "10j", opt)
  map("n", "K", "10k", opt)
  -- map("v", "<C-d>", "10j", opt)
  -- map("v", "<C-i>", "10j", opt)

  -- split
  map("n", "<leader>sh", ":split<CR>", opt)
  map("n", "<leader>sv", ":vsplit<CR>", opt)
  map("n", "<leader>sc", ":close<CR>", opt)

  -- refresh files
  map("n", "<leader>rr", ":checktime<CR>", opt)

  -- 粘贴替换
  map("n", "<leader>ri", "ciw<C-r>0<ESC>", opt)

  -- set keybinds for both INSERT and VISUAL.
  map("i", "<C-n>", "<Plug>luasnip-next-choice", {})
  map("s", "<C-n>", "<Plug>luasnip-next-choice", {})
  map("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
  map("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

  -- switch to normal mode
  map("i", "jk", "<ESC>", opt)
  map("v", "q", "<ESC>", opt)


  -- 单行或多行移动
  map("v", "J", ":m '>+1<CR>gv=gv", opt)
  map("v", "K", ":m '<-2<CR>gv=gv", opt)

  -- 移动到行首或者行尾，($ ^ 不好按)
  map("v", "H", "0", opt)
  map("v", "L", "$", opt)
  map("n", "H", "0", opt)
  map("n", "L", "$", opt)

  -- 移动到行尾，（v模式下，使用 $ 移动到行尾多一个字符）
  -- keymap("v", "L", function ()
  --   local cursor = vim.api.nvim_win_get_cursor(0)
  --   local line = vim.api.nvim_get_current_line()
  --   local len = string.len(line)
  --   vim.api.nvim_win_set_cursor(0, {cursor[1], len - 1})
  -- end, opt)



  -- 删除当前位置至行尾
  map("n", "dL", "d$", opt)

  -- 全选
  map("n", "yie", ":%y+<CR>", opt)

  -- 括号跳转
  map("n", "<C-e>", "%", opt)
  map("v", "<C-e>", "%", opt)

  -- Hop
  keymap("n", "fl", "<Cmd>HopLine<CR>", opt)
  keymap("n", "fw", "<Cmd>HopWordCurrentLine<CR>", opt)
  keymap("n", "fa", "<Cmd>HopChar1CurrentLine<CR>", opt)
  keymap("n", "ff", "<Cmd>HopWord<CR>", opt)
  -- keymap("n", "s", "<Cmd>HopChar2<CR>", opt)


  -- todo-comments
  keymap("n", "]t", function()
    require("todo-comments").jump_next()
  end, { desc = "Next todo comment" })

  keymap("n", "[t", function()
    require("todo-comments").jump_prev()
  end, { desc = "Previous todo comment" })
end
-- lsp 回调函数快捷键设置
M.maplsp = function(client, buffer)
  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_buf_set_option(buffer, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  local bufopts = { noremap = true, silent = true, buffer = buffer }
  vim.api.nvim_buf_set_keymap(buffer, "n", "N", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
  -- rename
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opt)
  -- mapbuf('n', '<leader>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opt)
  -- code action
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "v", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opt)
  -- mapbuf('n', '<leader>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opt)
  -- go xx
  -- mapbuf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gj", "<cmd>Telescope lsp_definitions<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opt)
  -- mapbuf('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opt)
  -- mapbuf('n', 'gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opt)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>Trouble lsp_type_definitions<CR>", opt)
  -- mapbuf('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opt)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>Trouble lsp_implementations<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gi", "<cmd>Telescope lsp_implementations<CR>", opt)
  -- mapbuf('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opt)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>Trouble lsp_references<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "gr", "<cmd>Telescope lsp_references<CR>", opt)
  -- mapbuf('n', 'gr', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', opt)
  -- mapbuf('n', '<space>s', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opt)
  -- mapbuf('n', '<space>s', '<cmd>lua require"telescope.builtin".lsp_workspace_symbols({ query = vim.fn.input("Query> ") })<CR>', opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opt)
  keymap("v", "<leader>fs", function()
    local tb = require("telescope.builtin")
    local text = require("kide.core.utils").get_visual_selection()
    tb.lsp_workspace_symbols({ default_text = text, query = text })
  end, opt)

  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>fo", "<cmd>Telescope lsp_document_symbols<CR>", opt)
  -- diagnostic
  vim.api.nvim_buf_set_keymap(buffer, "n", "go", "<cmd>lua vim.diagnostic.open_float()<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opt)
  vim.api.nvim_buf_set_keymap(buffer, "n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opt)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "[e",
    "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
    opt
  )
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "]e",
    "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
    opt
  )

  -- keymap("n", "<leader>=", function()
  --   local bfn = vim.api.nvim_get_current_buf()
  --   vim.lsp.buf.format({
  --     bufnr = bfn,
  --     filter = function(c)
  --       return require("kide.lsp.utils").filter_format_lsp_client(c, bfn)
  --     end,
  --   })
  -- end, bufopts)
  -- vim.api.nvim_buf_set_keymap(
  --   buffer,
  --   "v",
  --   "<leader>=",
  --   '<cmd>lua require("kide.lsp.utils").format_range_operator()<CR>',
  --   opt
  -- )

  vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>xw", "<cmd>Telescope diagnostics<CR>", opt)
  vim.api.nvim_buf_set_keymap(
    buffer,
    "n",
    "<leader>xe",
    "<cmd>lua require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.ERROR })<CR>",
    opt
  )
  -- >= 0.8.x
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd(string.format("au CursorHold  <buffer=%d> lua vim.lsp.buf.document_highlight()", buffer))
    vim.cmd(string.format("au CursorHoldI <buffer=%d> lua vim.lsp.buf.document_highlight()", buffer))
    vim.cmd(string.format("au CursorMoved <buffer=%d> lua vim.lsp.buf.clear_references()", buffer))
  end
  local codeLensProvider = client.server_capabilities.codeLensProvider
  if codeLensProvider then
    vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>cr", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", opt)
    vim.api.nvim_buf_set_keymap(buffer, "n", "<leader>ce", "<Cmd>lua vim.lsp.codelens.run()<CR>", opt)
  end
end

-- nvim-cmp 自动补全
M.cmp = function(cmp)
  local luasnip = require("luasnip")
  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  end
  return {
    -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
    }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      local neogen = require("neogen")
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif neogen.jumpable() then
        neogen.jump_next()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      local neogen = require("neogen")
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      elseif neogen.jumpable(true) then
        neogen.jump_prev()
      else
        fallback()
      end
    end, { "i", "s" }),
  }
end

M.ufo_mapkey = function()
  -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  vim.keymap.set("n", "zR", require("ufo").openAllFolds)
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
end

M.easy_align = function()
  -- vim-easy-align
  keymap("n", "ga", "<Plug>(EasyAlign)")
  keymap("x", "ga", "<Plug>(EasyAlign)")
end

return M
