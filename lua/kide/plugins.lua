-- local config = require("kide.config")
local core_plugins = {

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({})
    end,
    lazy = true,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("kide.plugins.config.mason").setup()
    end,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    event = "User FileOpened",
    lazy = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    config = function()
      require("mason-lspconfig").setup(nvim.lsp.installer.setup)

      -- automatic_installation is handled by lsp-manager
      local settings = require "mason-lspconfig.settings"
      settings.current.automatic_installation = false
    end,
    lazy = true,
    event = "User FileOpened",
    dependencies = "mason.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufNewFile", "BufReadPost" },
    -- config = function()
    --   require("kide.lsp")
    -- end,
    dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
  },
  { "tamago324/nlsp-settings.nvim", cmd = "LspSettings", lazy = true },
  {
    "folke/neodev.nvim",
    lazy = true,
  },
  -- 代码片段
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require("nvim.core.illuminate").setup()
    end,
    event = "User FileOpened",
    enabled = nvim.builtin.illuminate.active,
  },
  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    build = "make install_jsregexp",
    config = function()
      require("kide.plugins.config.luasnip")
    end,
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = { "L3MON4D3/LuaSnip" },
    lazy = true,
  },
  -- lspkind
  {
    "onsails/lspkind-nvim",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("lspkind").init({
        -- preset = "codicons",
        symbol_map = {
          Copilot = "",
        },
      })
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "VeryLazy" },
    keys = { ":", "/", "?" },
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
    },
    lazy = true,
    config = function()
      require("kide.plugins.config.nvim-cmp")
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
  },
  -- 主题
  -- use 'morhetz/gruvbox'
  {
    "ellisonleao/gruvbox.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("kide.theme.gruvbox").setup()
    end,
  },
  {
    "sainnhe/gruvbox-material",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = "dark"
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_better_performance = true
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },
  {
    "catppuccin/nvim",
    enabled = true,
    lazy = nvim.colorscheme ~= "catppuccin",
    priority = 1000,
    -- config = function()
    --   require("kide.theme.catppuccin").setup()
    -- end
  },

  -- 文件管理
  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    cmd = "NvimTreeToggle",
    version = "*",
    config = function()
      require("kide.plugins.config.nvim-tree")
    end,
  },

  -- using packer.nvim
  {
    "akinsho/bufferline.nvim",
    version = "*",
    requires = "kyazdani42/nvim-web-devicons",
    after = "catppuccin",
    config = function()
      require("kide.plugins.config.bufferline")
    end,
  },

  -- treesitter (新增)
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufNewFile", "BufReadPost" },
    build = ":TSUpdate",
    config = function()
      require("kide.plugins.config.nvim-treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufNewFile", "BufReadPost" },
  },

  -- java
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
    ft = "java",
    init = function()
      -- 不加载 nvim-jdtls.vim
      vim.g.nvim_jdtls = 1
      vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
        pattern = "jdt://*",
        callback = function(e)
          require("jdtls").open_classfile(e.file)
        end,
      })
      vim.api.nvim_create_user_command(
        "JdtWipeDataAndRestart",
        "lua require('jdtls.setup').wipe_data_and_restart()",
        {}
      )
      vim.api.nvim_create_user_command("JdtShowLogs", "lua require('jdtls.setup').show_logs()", {})

      local group = vim.api.nvim_create_augroup("kide_jdtls_java", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = group,
        pattern = { "java" },
        desc = "jdtls",
        callback = function(e)
          if e.file == "java" and vim.bo[e.buf].buftype == "nofile" then
            -- ignore
          else
            require("kide.lsp.java").start()
          end
        end,
      })
      return group
    end,
  },
  {
    "JavaHello/java-deps.nvim",
    lazy = true,
    ft = "java",
    dependencies = "mfussenegger/nvim-jdtls",
    config = function()
      require("java-deps").setup({})
    end,
  },
  {
    "scalameta/nvim-metals",
    lazy = true,
    ft = "scala",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("kide.lsp.metals").setup()
    end,
  },
  -- debug
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("kide.dap")
      -- require("telescope").load_extension("dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    event = { "VeryLazy" },
    config = function()
      require("kide.plugins.config.nvim-dap-ui")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    event = { "VeryLazy" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },

  {
    -- todo
    -- "mfussenegger/nvim-dap-python",
    -- lazy = true,
    -- ft = "java",
    -- dependencies = { "mfussenegger/nvim-dap" },
    -- config = function()
    --   require("dap-python").setup(config.env.py_bin)
    -- end,
  },

  -- 搜索插件
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = { "VeryLazy" },
    cmd = { "Telescope" },
    keys = { "<leader>" },
    tag = "0.1.1",
    config = function()
      require("kide.plugins.config.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
  },

  {
    "LinArcX/telescope-env.nvim",
    lazy = true,
  },
  -- 项目管理
  {
    "nvim-telescope/telescope-project.nvim",
    lazy = true,
  },

  -- git
  {
    "tpope/vim-fugitive",
    layz = true,
    cmd = { "Git" },
  },
  {
    "sindrets/diffview.nvim",
    layz = true,
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    config = function()
      require("kide.plugins.config.diffview-nvim")
    end,
  },
  {
    "TimUntersberger/neogit",
    layz = true,
    cmd = "Neogit",
    dependencies = { "sindrets/diffview.nvim" },
    config = function()
      require("kide.plugins.config.neogit")
    end,
  },

  -- git edit 状态显示插件
  {
    "lewis6991/gitsigns.nvim",
    layz = true,
    event = { "VeryLazy", "BufReadPost" },
    config = function()
      require("kide.plugins.config.gitsigns-nvim")
    end,
  },

  -- 浮动窗口插件
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    version = "*",
    cmd = { "ToggleTerm" },
    config = function()
      require("toggleterm").setup({
        shade_terminals = true,
        -- shade_filetypes = { "none", "fzf" },
        direction = "float",
        close_on_exit = true,
        float_opts = {
          border = "double",
          winblend = 0,
        },
      })
    end,
  },

  -- 异步任务执行插件
  {
    "jedrzejboczar/toggletasks.nvim",
    lazy = true,
    dependencies = { "akinsho/toggleterm.nvim" },
    config = function()
      require("kide.plugins.config.toggletasks")
    end,
  },

  -- 多光标插件
  {
    "mg979/vim-visual-multi",
    lazy = true,
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "visual multi" },
    },
  },

  -- 状态栏插件
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("kide.plugins.config.lualine")
    end,
  },

  -- blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost" },
    config = function()
      require("kide.plugins.config.indent-blankline")
    end,
  },

  -- 大纲插件
  {
    "simrat39/symbols-outline.nvim",
    lazy = true,
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
    config = function()
      require("kide.plugins.config.symbols-outline")
    end,
  },

  -- 消息通知
  {
    "rcarriga/nvim-notify",
    config = function()
      require("kide.plugins.config.nvim-notify")
    end,
  },

  -- wildmenu 补全美化
  {
    "gelguy/wilder.nvim",
    enabled = false,
    keys = { ":", "/", "?" },
    config = function()
      require("kide.plugins.config.wilder")
    end,
  },

  -- 颜色显示
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "InsertEnter", "VeryLazy" },
    config = function()
      require("kide.plugins.config.nvim-colorizer")
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = { "n" }, desc = "Comment" },
      { "gc",  mode = { "x" }, desc = "Comment" },
    },
    config = function()
      require("kide.plugins.config.comment")
    end,
  },
  {
    "danymat/neogen",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("kide.plugins.config.neogen")
    end,
  },

  -- mackdown 预览插件
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = "markdown",
    build = "cd app && yarn install",
    config = function()
      require("kide.plugins.config.markdown-preview")
    end,
  },
  -- mackdown cli 预览插件
  {
    "ellisonleao/glow.nvim",
    lazy = true,
    ft = "markdown",
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
      })
    end,
  },
  -- pandoc 命令插件(用于md转pdf)
  {
    "aspeddro/pandoc.nvim",
    lazy = true,
    ft = "markdown",
    config = function()
      require("kide.plugins.config.pandoc")
    end,
  },

  -- 快捷键查看
  {
    "folke/which-key.nvim",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("kide.plugins.config.which-key")
    end,
  },

  -- 仪表盘
  {
    "goolord/alpha-nvim",
    config = function()
      require("kide.plugins.config.alpha-nvim")
    end,
  },

  -- 翻译插件
  {
    "uga-rosa/translate.nvim",
    lazy = true,
    cmd = "Translate",
    config = function()
      require("kide.plugins.config.translate")
    end,
  },
  -- StartupTime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
  -- 自动对齐插件
  {
    "junegunn/vim-easy-align",
    lazy = true,
    cmd = "EasyAlign",
    config = function()
      require("kide.core.keybindings").easy_align()
    end,
  },

  -- 表格模式插件
  {
    "dhruvasagar/vim-table-mode",
    lazy = true,
    cmd = { "TableModeEnable" },
  },

  -- () 自动补全
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter", "VeryLazy" },
    config = function()
      require("kide.plugins.config.nvim-autopairs")
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },

  -- 任务插件
  {
    "itchyny/calendar.vim",
    lazy = true,
    cmd = {
      "Calendar",
    },
  },

  -- rust
  {
    "simrat39/rust-tools.nvim",
    lazy = true,
  },

  {
    "NTBBloodbath/rest.nvim",
    lazy = true,
    ft = "http",
    config = function()
      require("kide.plugins.config.rest-nvim")
    end,
  },

  -- 选中高亮插件
  {
    "RRethy/vim-illuminate",
    lazy = true,
    event = { "BufReadPost" },
    config = function()
      require("kide.plugins.config.vim-illuminate")
    end,
  },

  -- 快速跳转 leap or hop, current is leap
  {
    "ggandor/leap.nvim",
    lazy = true,
    keys = { "s", "S" },
    config = function()
      require("leap").add_default_mappings()
      require("leap").opts.safe_labels = {}
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "phaazon/hop.nvim",
    branch = "v2",
    lazy = false,
    config = function()
      require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  -- 自动保存当前打开的窗口 (nvim启动时不带任何参数生效)
  -- 手动保存：SessionSave, SessionRestore
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function ()
      require("auto-session").setup {
        log_level = "error",
        auto_session_enable = true,
        auto_save_enable = true,
        auto_restore_enable = true,
        auto_session_create_enabled = true,
        -- auto save all dirs except suppress_dirs
        auto_session_auto_session_allowed_dirs = {  },
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
      }
    end
  },


  -- LSP 进度
  {
    "j-hui/fidget.nvim",
    lazy = true,
    branch = "legacy",
    config = function()
      require("fidget").setup({
        text = {
          done = "",
        },
      })
    end,
  },

  -- 查找替换
  {
    "windwp/nvim-spectre",
    lazy = true,
    config = function()
      require("spectre").setup()
    end,
  },

  -- ASCII 图
  {
    "jbyuki/venn.nvim",
    lazy = true,
    cmd = { "VBox" },
  },

  {
    "tversteeg/registers.nvim",
    lazy = true,
    cmd = { "Registers" },
    keys = '"',
    config = function()
      require("registers").setup()
    end,
  },

  -- databases
  -- https://alpha2phi.medium.com/neovim-for-beginners-database-explorer-7db3d3910876
  -- 客户端说明，每种数据库都只能使用原生客户端，alias不行，会有which命令校验路径
  -- mysql-client: brew install mysql-client
  -- redis: ln -s
  {
    "nanotee/sqls.nvim",
    lazy = true,
    module = { "sqls" },
    ft = { "sql", "mysql" },
    cmd = {
      "SqlsExecuteQuery",
      "SqlsExecuteQueryVertical",
      "SqlsShowDatabases",
      "SqlsShowSchemas",
      "SqlsShowConnections",
      "SqlsSwitchDatabase",
      "SqlsSwitchConnection",
    },
  },
  {
    "tpope/vim-dadbod",
    lazy = true,
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      require("kide.plugins.config.dadbod").setup()
    end,
    cmd = { "DBUIToggle", "DBUI", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = true,
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
  },

  {
    "aklt/plantuml-syntax",
    lazy = true,
    ft = "plantuml",
  },

  -- 浏览器搜索
  {
    "lalitmee/browse.nvim",
    lazy = true,
    cmd = {
      "Browse",
    },
    config = function()
      require("kide.plugins.config.browse-nvim")
    end,
  },

  -- 环绕输入
  {
    "kylechui/nvim-surround",
    lazy = true,
    version = "*",
    event = { "VeryLazy" },
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  --  Create custom submodes and menus
  {
    "anuvyklack/hydra.nvim",
    lazy = true,
  },

  -- 代码状态栏导航 (位于窗口顶部，tabs下方)
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    event = "User FileOpened",
    config = function()
      require("kide.plugins.config.nvim-navic").setup()
    end,
  },

  -- 笔记
  {
    "mickael-menu/zk-nvim",
    lazy = true,
    cmd = {
      "ZkIndex",
      "ZkNew",
      "ZkNotes",
    },
    config = function()
      require("kide.plugins.config.zk-nvim")
    end,
  },

  -- 折叠
  {
    "kevinhwang91/promise-async",
    lazy = true,
  },
  {
    "kevinhwang91/nvim-ufo",
    lazy = true,
    event = { "BufReadPost" },
    config = function()
      require("kide.plugins.config.nvim-ufo")
    end,
  },

  -- ui
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- chatgpt
  {
    "jackMort/ChatGPT.nvim",
    lazy = true,
    cmd = {
      "ChatGPT",
    },
    config = function()
      require("chatgpt").setup({
        keymaps = {
          submit = "<C-e>",
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    lazy = true,
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    -- "zbirenbaum/copilot.lua",
    -- enabled = config.plugin.copilot.enable,
    -- lazy = true,
    -- cmd = "Copilot",
    -- config = function()
    --   require("copilot").setup({
    --     suggestion = { enabled = false },
    --     panel = { enabled = false },
    --   })
    -- end,
  },
  {
    -- "zbirenbaum/copilot-cmp",
    -- enabled = config.plugin.copilot.enable,
    -- lazy = true,
    -- dependencies = { "zbirenbaum/copilot.lua" },
    -- event = { "InsertEnter", "VeryLazy" },
    -- config = function()
    --   require("copilot_cmp").setup()
    -- end,
  },
  { "Tastyep/structlog.nvim", lazy = true },
}

return core_plugins
