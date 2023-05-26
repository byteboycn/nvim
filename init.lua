-- math.randomseed(os.time())
require("kide.core")
require("kide.plugins")

-- 自动切换输入法 (更多事件参考：https://neovim.io/doc/user/autocmd.html#autocmd-events)
vim.cmd('autocmd InsertLeave * :silent :!inputsource com.apple.keylayout.ABC')
vim.cmd('autocmd VimEnter * :silent :!inputsource com.apple.keylayout.ABC')
vim.cmd('autocmd FocusGained * :silent :!inputsource com.apple.keylayout.ABC')
