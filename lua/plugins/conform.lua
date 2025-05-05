return {
	{
		"stevearc/conform.nvim",
		enabled = true,
		opts = {
			formatters_by_ft = {
				lua = { command = "stylua", env = {} },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				-- Conform will run multiple formatters sequentially
				go = { "goimports", "gofmt" },

				xml = { "xmllint" },

				java = { "google-java-format_linux" }
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = { "xml", "java" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end
				-- ...additional logic...
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,

		},
	},
}
