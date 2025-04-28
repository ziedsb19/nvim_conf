return {
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
		config = function()
			-- [[ Configure nvim-cmp ]]
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			require('luasnip.loaders.from_vscode').lazy_load()
			luasnip.config.setup {}

			cmp.setup({

				-- -- Disabling completion in certain contexts, such as comments
				-- enabled = function()
				-- 	-- disable completion in comments
				-- 	local context = require 'cmp.config.context'
				-- 	-- keep command mode completion enabled when cursor is in a comment
				-- 	if vim.api.nvim_get_mode().mode == 'c' then
				-- 		return true
				-- 	else
				-- 		return not context.in_treesitter_capture("comment")
				-- 			and not context.in_syntax_group("Comment")
				-- 	end
				-- end,

				completion = {
					-- completeopt = 'menu,menuone,noinsert',
				},

				snippet = {
					expand = function(args) luasnip.lsp_expand(args.body) end,
				},

				formatting = {

					fields = { "kind", "abbr", "menu" },

					format = function(entry, vim_item)
						local kind_icons = {
							Text = "",
							Method = "",
							Function = "󰊕",
							Constructor = "",
							Field = "", -- 
							Variable = "",
							Class = '', -- ﴯ
							Interface = "",
							Module = "",
							Property = "",
							Unit = "",
							Value = "",
							Enum = "",
							Keyword = "",
							Snippet = "",
							Color = "",
							File = "",
							Reference = "",
							Folder = "",
							EnumMember = "",
							Constant = "",
							Struct = "",
							Event = "",
							Operator = '', -- 
							TypeParameter = '  ',
						}

						vim_item.kind = (kind_icons[vim_item.kind] or '') .. " "
						-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- show icons with the name of the item kind

						-- limit completion width
						local MAX_LABEL_WIDTH = 35
						local label = vim_item.abbr
						local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
						if truncated_label ~= label then
							vim_item.abbr = truncated_label .. '…'
						end

						-- set a name for each source
						vim_item.menu = ({
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							nvim_lua = "[Lua]",
							latex_symbols = "[LaTeX]",
						})[entry.source.name]

						return vim_item
					end,
				},

				sources = {
					{ name = 'nvim_lsp' },
					-- {name = 'nvim_lsp_signature_help' }, -- using ray-x/lsp_signature.nvim instead
					{ name = 'nvim_lua' },
					{ name = 'path' },
					{ name = 'luasnip' },
					{ name = 'buffer',  keyword_length = 1 },
					-- {name = 'calc'},
				},

				window = {
					documentation = {
						border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
					},
					completion = {
						border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
					}
				},

				experimental = {
					-- ghost_text = true,
				},

			})

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-d>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				},
			}
		end
	},
}
