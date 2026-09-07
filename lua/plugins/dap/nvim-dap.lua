-- Debugging Support
return {
	-- https://github.com/rcarriga/nvim-dap-ui
	'rcarriga/nvim-dap-ui',
	event = 'VeryLazy',
	enabled = false,
	dependencies = {
		-- https://github.com/mfussenegger/nvim-dap
		'mfussenegger/nvim-dap',
		-- https://github.com/nvim-neotest/nvim-nio
		'nvim-neotest/nvim-nio',
		-- https://github.com/theHamsta/nvim-dap-virtual-text
		'theHamsta/nvim-dap-virtual-text', -- inline variable text while debugging
		-- https://github.com/nvim-telescope/telescope-dap.nvim
		'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
	},
	opts = {
		controls = {
			element = "repl",
			enabled = true,
			icons = {
				disconnect = "",
				pause = "",
				play = "",
				run_last = "",
				step_back = "",
				step_into = "",
				step_out = "",
				step_over = "",
				terminate = ""
			}
		},
		element_mappings = {},
		expand_lines = true,
		floating = {
			border = "single",
			mappings = {
				close = { "q", "<Esc>" }
			}
		},
		force_buffers = true,
		icons = {
			collapsed = "",
			current_frame = "",
			expanded = ""
		},
		layouts = {
			{
				elements = {
					{
						id = "scopes",
						size = 0.50
					},
					{
						id = "stacks",
						size = 0.30
					},
					{
						id = "watches",
						size = 0.10
					},
					{
						id = "breakpoints",
						size = 0.10
					}
				},
				size = 40,
				position = "left", -- Can be "left" or "right"
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 10,
				position = "bottom", -- Can be "bottom" or "top"
			}
		},
		mappings = {
			edit = "e",
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			repl = "r",
			toggle = "t"
		},
		render = {
			indent = 1,
			max_value_lines = 100
		}
	},
	config = function(_, opts)
		local dap = require('dap')
		require('dapui').setup(opts)

		-- Customize breakpoint signs
		vim.api.nvim_set_hl(0, "DapStoppedHl", { fg = "#98BB6C", bg = "#2A2A2A", bold = true })
		vim.api.nvim_set_hl(0, "DapStoppedLineHl", { bg = "#204028", bold = true })
		vim.fn.sign_define('DapStopped',
			{ text = '', texthl = 'DapStoppedHl', linehl = 'DapStoppedLineHl', numhl = '' })
		vim.fn.sign_define('DapBreakpoint',
			{ text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
		vim.fn.sign_define('DapBreakpointCondition',
			{ text = '', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
		vim.fn.sign_define('DapBreakpointRejected',
			{ text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
		vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' })

		dap.listeners.after.event_initialized["dapui_config"] = function()
			-- require('dapui').open()
		end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			-- Commented to prevent DAP UI from closing when unit tests finish
			-- require('dapui').close()
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			-- Commented to prevent DAP UI from closing when unit tests finish
			-- require('dapui').close()
		end

		-- Add dap configurations based on your language/adapter settings
		-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		dap.configurations.java = {
			-- {
			-- 	name = "Debug Launch (2GB)",
			-- 	type = 'java',
			-- 	request = 'launch',
			-- 	vmArgs = "" ..
			-- 	    "-Xmx2g "
			-- },
			-- {
			-- 	name = "Debug Attach (8000)",
			-- 	type = 'java',
			-- 	request = 'attach',
			-- 	hostName = "127.0.0.1",
			-- 	port = 8000,
			-- },
			-- {
			-- 	name = "Debug Attach (5005)",
			-- 	type = 'java',
			-- 	request = 'attach',
			-- 	hostName = "127.0.0.1",
			-- 	port = 5005,
			-- },
			{
				name = "Dev -server",
				type = "java",
				request = "launch",
				-- You need to extend the classPath to list your dependencies.
				-- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
				-- classPaths = {},

				-- If using multi-module projects, remove otherwise.
				projectName = "datahub-app-client",

				javaExec = "java",
				mainClass = "lib.main.Server",

				args =
				"-export //localhost:8010/SmartServer -db /nxdh/conf/database.cfg -loglevel EFWIT -nodbchk -v /nxdh/conf/verbose.cfg -log NONE",

				-- If using the JDK9+ module system, this needs to be extended
				-- `nvim-jdtls` would automatically populate this property
				-- modulePaths = {},
				vmArgs = "" ..
				    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
			},
			{
				name = "Dev -server 1 (elastic cluster)",
				type = "java",
				request = "launch",
				projectName = "datahub-app-client",
				javaExec = "java",
				mainClass = "lib.main.Server",
				args =
				"-export //localhost:8010/SmartServer -db /nxdh/conf/database.cfg -loglevel EFWIT -nodbchk -v /nxdh/conf/verbose.cfg -log NONE -elasticcluster /nxdh/conf/cluster.cfg -P SERVER_SMART_0",
				vmArgs = "" ..
				    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
			},
			{
				name = "Dev -server 2 (elastic cluster)",
				type = "java",
				request = "launch",
				projectName = "datahub-app-client",
				javaExec = "java",
				mainClass = "lib.main.Server",
				args =
				"-export //localhost:9010/SmartServer -db /nxdh/conf/database.cfg -loglevel EFWIT -nodbchk -v /nxdh/conf/verbose.cfg -log NONE -elasticcluster /nxdh/conf/cluster.cfg -P SERVER_SMART_1",
				vmArgs = "" ..
				    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
			},
			{
				name = "Dev -sheduler 1 (elastic cluster)",
				type = "java",
				request = "launch",
				projectName = "datahub-app-client",
				javaExec = "java",
				mainClass = "lib.main.Run",
				console = "integratedTerminal",
				args =
				"-user Scheduler -P SCHEDULER_SMART_0 -daemon scheduler -log NONE -loglevel EFWIT -v /nxdh/conf/verbose.cfg -network /nxdh/conf/network.cfg -cluster SERVER_SMART_0=//localhost:9010/SmartServer; -clustermode -P SCHEDULER_SMART_0 -terminationPeriod 1800 -terminationMarkPath /tmp -multiprocess /nxdh/conf/multiprocess.cfg",
				vmArgs = "" ..
				    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
			},
			{
				name = "Dev -sheduler 1 (multiprocess cloud)",
				type = "java",
				request = "launch",
				projectName = "datahub-app-client",
				javaExec = "java",
				mainClass = "lib.main.Run",
				console = "integratedTerminal",
				args =
				"-user Scheduler -P SCHEDULER_SMART_0 -daemon scheduler -log NONE -loglevel EFWIT -v /nxdh/conf/verbose.cfg -network /nxdh/conf/network.cfg -cluster SERVER_SMART_0=//10.1.1.194:9010/SmartServer; -clustermode -P SCHEDULER_SMART_0 -terminationPeriod 1800 -terminationMarkPath /tmp -multiprocess /nxdh/conf/multiprocess.cfg",
				vmArgs = "" ..
				    "-server -Xmx2G -Xms512M -Djava.locale.providers=COMPAT,CLDR  -Dfile.encoding=UTF-8 --add-opens java.base/java.nio=ALL-UNNAMED"
			}
		}

		require("dap-go").setup()
		require("dap-python").setup(
			"/home/zied/.cache/pypoetry/virtualenvs/harlequin-7iRZJbFj-py3.12/bin/python")
	end
}
