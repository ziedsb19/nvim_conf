local on_attach = require("utils.common")
local home = vim.env.HOME

local jdtls = require("jdtls")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = home .. "/jdtls-workspace/" .. project_name

local bundles = vim.split(
	vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
	"\n")
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

local config = {
	cmd = {
		"/usr/lib/jvm/java-21-openjdk-amd64/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=false",
		"-Dlog.level=ERROR",
		"-Xms512m",
		"-Xmx4g",
		"-XX:+UseG1GC",
		"-XX:G1HeapRegionSize=16m",
		"-XX:+ParallelRefProcEnabled",
		"-XX:+UseStringDeduplication",
		"-Dsun.zip.disableMemoryMapping=true",
		"--add-modules=ALL-SYSTEM,jdk.incubator.vector",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
		"-data", workspace_dir,
	},

	settings = {
		java = {
			autobuild = { enabled = false },

			eclipse = { downloadSources = false },

			maven = {
				downloadSources = false,
				updateSnapshots = false,
			},

			import = {
				exclusions = {
					"**/node_modules/**",
					"**/.metadata/**",
					"**/archetype-resources/**",
					"**/META-INF/maven/**",
					"**/target/**",
					"**/.git/**",
				},
				maven = { enabled = true },
				gradle = { enabled = true },
			},

			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{ name = "JavaSE-1.8", path = "/opt/jvm/jdk8u372-b07" },
					{ name = "JavaSE-17",  path = "/opt/jvm/jdk-17" },
				},
			},

			completion = {
				guessMethodArguments = "off",
				importOrder = { "java", "javax", "com", "org" },
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},

			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},

			implementationsCodeLens = { enabled = false },
			referencesCodeLens = { enabled = false },
			signatureHelp = { enabled = true },

			format = { enabled = true },

			codeGeneration = {
				toString = {
					template =
					"${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},

	capabilities = require("cmp_nvim_lsp").default_capabilities(),

	flags = {
		allow_incremental_sync = true,
		debounce_text_changes = 150,
	},

	init_options = {
		bundles = bundles,
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
	},
}

config["on_attach"] = function(client, bufnr)
	on_attach(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	-- require("jdtls.dap").setup_dap_main_class_configs()
end

jdtls.start_or_attach(config)
