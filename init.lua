-- math.randomseed(os.time())
require("kide.core")
require("kide.plugins")

-- 自动切换输入法
vim.cmd('autocmd InsertLeave * :silent :!inputsource com.apple.keylayout.ABC')
vim.cmd('autocmd VimEnter * :silent :!inputsource com.apple.keylayout.ABC')

