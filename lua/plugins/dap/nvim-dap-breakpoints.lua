return {
	"Weissle/persistent-breakpoints.nvim",
	event = "BufReadPost",               -- Standard event to reload breakpoints
	dependencies = { "mfussenegger/nvim-dap" }, -- Forces DAP to load first
	config = function()
		require("dap")
		-- local signs = {
		-- 	DapBreakpoint          = { text = "", texthl = "DapBreakpoint", linehl = "SignColumn", numhl = "" },
		-- 	DapBreakpointCondition = { text = " ", texthl = "DapBreakpoint", linehl = "SignColumn", numhl = "" },
		-- 	DapLogPoint            = { text = " ", texthl = "DapLogPoint", linehl = "SignColumn", numhl = "" },
		-- 	DapStopped             = { text = "➡️", texthl = "DapStopped", linehl = "DiagnosticUnderlineInfo", numhl = "DapStopped" },
		-- 	DapBreakpointRejected  = { text = "⚠️", texthl = "DapBreakpointLight", linehl = "", numhl = "" },
		-- }
		--
		-- for name, sign in pairs(signs) do
		-- 	vim.fn.sign_define(name, sign)
		-- end
		require("persistent-breakpoints").setup({
			load_breakpoints_event = { "BufReadPost" },
		})

		-- Replace standard dap keymaps with persistent ones
		vim.keymap.set("n", "<leader>db", function()
			require("persistent-breakpoints.api").toggle_breakpoint()
		end, { desc = "DAP toggle breakpoint" })
		vim.keymap.set("n", "<leader>dB", function()
			require("persistent-breakpoints.api").clear_all_breakpoints()
		end, { desc = "DAP clear all breakpoint" })
	end,
}
