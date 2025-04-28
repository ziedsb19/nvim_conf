local on_attach = require("utils.common")
-- JDTLS (Java LSP) configuration
local home = vim.env.HOME -- Get the home directory

local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name

local system_os = ""

-- Determine OS
if vim.fn.has("mac") == 1 then
	system_os = "mac"
elseif vim.fn.has("unix") == 1 then
	system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	system_os = "win"
else
	print("OS not found, defaulting to 'linux'")
	system_os = "linux"
end

-- Needed for debugging
local bundles = {
	vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	cmd = {
		--
		"/usr/lib/jvm/java-21-openjdk-amd64/bin/java", -- Or the absolute path '/path/to/java11_or_newer/bin/java'
		"-agentlib:jdwp=transport=dt_socket,address=localhost:5005,server=y,suspend=n",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		--
		"-jar",
		-- "/home/zied/opensource/plugins/org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar",
		"/home/zied/opensource/git/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.7.0.v20250419-1434.jar",
		"-configuration",
		-- "/home/zied/opensource/config_linux",
		"/home/zied/opensource/git/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",
		"-data", workspace_dir
	},


	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},

			maven = {
				downloadSources = true,
			},


			configuration = {
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/opt/jvm/jdk8u372-b07",
					},
					{
						name = "JavaSE-17",
						path = "/opt/jvm/jdk-17",
					},
					-- {
					-- 	name = "JavaSE-19",
					-- 	path = "/usr/lib/jvm/java-19-openjdk-amd64",
					-- },
					-- {
					-- 	name = "JavaSE-21",
					-- 	path = "/usr/lib/jvm/java-21-openjdk-amd64",
					-- },
				},

			}
		}
		--[[ java = {
			-- TODO Replace this with the absolute path to your main java version (JDTLS requires JDK 21 or higher)
			home = "/usr/lib/jvm/java-21-openjdk-amd64",
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				-- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
				-- The runtimes' name parameter needs to match a specific Java execution environments.  See https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request and search "ExecutionEnvironment".
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/opt/jvm/jdk8u372-b07",
					},
					{
						name = "JavaSE-11",
						path = "/usr/lib/jvm/java-11-openjdk-amd64",
					},
					{
						name = "JavaSE-17",
						path = "/opt/jvm/jdk-17",
					},
					{
						name = "JavaSE-19",
						path = "/usr/lib/jvm/java-19-openjdk-amd64",
					},
					{
						name = "JavaSE-21",
						path = "/usr/lib/jvm/java-21-openjdk-amd64",
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			signatureHelp = { enabled = true },
			format = {
				enabled = true,
				-- Formatting works by default, but you can refer to a specific file/URL if you choose
				-- settings = {
				--   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
				--   profile = "GoogleStyle",
				-- },
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template =
					"${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		}, ]]
	},
	-- Needed for auto-completion with method signatures and placeholders
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	flags = {
		allow_incremental_sync = true,
	},
	init_options = {
		-- References the bundles defined above to support Debugging and Unit Testing
		-- bundles = bundles,
		bundles = vim.split(vim.fn.glob("/home/zied/opensource/bundles/extension/server/*.jar"), "\n"),
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}
config["on_attach"] = function(client, bufnr)
	on_attach(client, bufnr)
	-- jdtls.setup_dap({ hotcodereplace = "auto" })
	-- require("jdtls.dap").setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
