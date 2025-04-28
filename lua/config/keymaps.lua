-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-Left>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-Down>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-Up>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-Right>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Go to Right Window", remap = true })


-- [[ Basic Keymaps ]]

-- vim.keymap.set('n', '<Tab>', '<c-w>w, { nnoremap = true }')

vim.keymap.set("v", "<M-/>", '<Esc>/\\%V', { desc = "search inside block" })

vim.keymap.set("n", "<c-a>", ':b#<cr>', { desc = "switch to last buffer" })

vim.keymap.set('n', '<c-n>', require('nvim-tree.api').tree.toggle, { desc = 'open tree' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>t', require('telescope-tabs').list_tabs, { desc = '[L]ist [T]abs' })
vim.keymap.set('n', '<leader>y', require("telescope").load_extension("yaml_schema").yaml_schema,
  { desc = '[G]o [T]o [P]revious [T]ab' })
vim.keymap.set("", "<leader>f", function()
  require("conform").format({ async = true }, function(err)
    if not err then
      local mode = vim.api.nvim_get_mode().mode
      if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
      end
    end
  end)
end, { desc = "Format code" })


local lspBuffKeymaps = {
  { '<leader>rn', vim.lsp.buf.rename,                                         '[R]e[n]ame' },
  { '<leader>ca', vim.lsp.buf.code_action,                                    '[C]ode [A]ction' },

  { 'gd',         require('telescope.builtin').lsp_definitions,               '[G]oto [D]efinition' },
  { 'gr',         require('telescope.builtin').lsp_references,                '[G]oto [R]eferences' },
  { 'gI',         require('telescope.builtin').lsp_implementations,           '[G]oto [I]mplementation' },
  { '<leader>D',  require('telescope.builtin').lsp_type_definitions,          'Type [D]efinition' },
  { '<leader>ds', require('telescope.builtin').lsp_document_symbols,          '[D]ocument [S]ymbols' },
  { '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols' },

  -- See `:help K` for why this keymap
  { 'K',          vim.lsp.buf.hover,                                          'Hover Documentation' },
  { '<C-k>',      vim.lsp.buf.signature_help,                                 'Signature Documentation' },

  -- Lesser used LSP functionality
  { 'gD',         vim.lsp.buf.declaration,                                    '[G]oto [D]eclaration' },
  { 'gR',         vim.lsp.buf.references,                                     '[G]oto [R]eferences in current buffer' },
  { '<leader>wa', vim.lsp.buf.add_workspace_folder,                           '[W]orkspace [A]dd Folder' },
  { '<leader>wr', vim.lsp.buf.remove_workspace_folder,                        '[W]orkspace [R]emove Folder' },
  { '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders' },

}

return {
  lspBuffKeymaps = lspBuffKeymaps
}
