return {
	{
		"stevearc/aerial.nvim",
		opts = {
			-- optionally use on_attach to set keymaps when aerial has attached to a buffer
			--
			attach_mode = "global",
			on_attach = function(bufnr)
				-- Jump forwards/backwards with '{' and '}'
				vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
				vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })

				vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")
			end,
		},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
