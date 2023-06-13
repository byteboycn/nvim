-- see more config
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jdtls
-- important: 本方式只能使用 lspconfig模式启动jdtls, 体验并不好，所以放弃本方式，使用nvim-jdtls模式
local Log = require("kide.core.log")
local env = {
  HOME = vim.loop.os_homedir(),
  JAVA_HOME = os.getenv("JAVA_HOME"),
  JDTLS_RUN_JAVA = os.getenv("JDTLS_RUN_JAVA"),
  JDTLS_HOME = os.getenv("JDTLS_HOME"),
  JDTLS_WORKSPACE = os.getenv("JDTLS_WORKSPACE"),
  LOMBOK_JAR = os.getenv("LOMBOK_JAR"),
  JOL_JAR = os.getenv("JOL_JAR"),
}

local function or_default(a, v)
  return require("kide.core.utils").or_default(a, v)
end

local function get_jdtls_workspace()
  return or_default(env.JDTLS_WORKSPACE, env.HOME .. "/jdtls-workspace/")
end

local function get_lombok_jar()
  return or_default(env.LOMBOK_JAR, "/opt/software/lsp/lombok.jar")
end

local jdtls_launcher = "jdtls"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = get_jdtls_workspace() .. project_name
local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })

local opts = {
  cmd = {
    jdtls_launcher,
    "--jvm-arg=-Dlog.protocol=true",
    "--jvm-arg=-Dlog.level=ALL",
    "--jvm-arg=-Dsun.zip.disableMemoryMapping=true",
    "--jvm-arg=" .. "-javaagent:" .. get_lombok_jar(),
    "--jvm-arg=" .. "-XX:+UseZGC",
    "--jvm-arg=" .. "-Xmx1g",
    "-data=" .. workspace_dir,
  },
  filetypes = { "java" },
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      templates = {
        fileHeader = {
          "/**",
          " * ${type_name}",
          " * @author ${user}",
          " */",
        },
        typeComment = {
          "/**",
          " * ${type_name}",
          " * @author ${user}",
          " */",
        },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
        updateSnapshots = true,
      },
    }
  },
}

return opts
