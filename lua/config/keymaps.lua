-- Move to window using the <ctrl> hjkl keys
-- vim.keymap.set("n", "<C-Left>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Go to Left Window", remap = true })
-- vim.keymap.set("n", "<C-Down>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Go to Lower Window", remap = true })
-- vim.keymap.set("n", "<C-Up>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Go to Upper Window", remap = true })
-- vim.keymap.set("n", "<C-Right>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Go to Right Window", remap = true })


vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l>", { desc = "Go to Right Window", remap = true })

-- [[ Basic Keymaps ]]

vim.keymap.set("v", "<M-/>", '<Esc>/\\%V', { desc = "search inside block" })
vim.keymap.set("n", "<c-a>", ':b#<cr>', { desc = "switch to last buffer" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Telescope keymaps
vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end,
  { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', function() require('telescope.builtin').buffers() end,
  { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', function() require('telescope.builtin').git_files() end,
  { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', function() require('telescope.builtin').grep_string() end,
  { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() require('telescope.builtin').live_grep() end,
  { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics() end,
  { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', function() require('telescope.builtin').resume() end, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>t', function() require('telescope-tabs').list_tabs() end, { desc = '[L]ist [T]abs' })
vim.keymap.set('n', '<leader>y', function()
  require("telescope").load_extension("yaml_schema").yaml_schema()
end, { desc = 'YAML Schema picker' })

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
  { '<leader>rn',  vim.lsp.buf.rename,                                                          '[R]e[n]ame' },
  { '<leader>ca',  vim.lsp.buf.code_action,                                                     '[C]ode [A]ction' },

  { 'gd',          function() require('telescope.builtin').lsp_definitions() end,               '[G]oto [D]efinition' },
  { 'gr',          function() require('telescope.builtin').lsp_references() end,                '[G]oto [R]eferences' },
  { 'gI',          function() require('telescope.builtin').lsp_implementations() end,           '[G]oto [I]mplementation' },
  { '<leader>D',   function() require('telescope.builtin').lsp_type_definitions() end,          'Type [D]efinition' },
  { '<leader>ds',  function() require('telescope.builtin').lsp_document_symbols() end,          '[D]ocument [S]ymbols' },
  { '<leader>ws',  function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, '[W]orkspace [S]ymbols' },

  { "<leader>dsn", function() require 'dap'.step_over() end,                                    "DAP step next" },
  { "<leader>dso", function() require 'dap'.step_out() end,                                     "DAP step out" },
  { "<leader>dsi", function() require 'dap'.step_into() end,                                    "DAP step in" },
  { "<leader>dc",  function() require 'dap'.continue() end,                                     "DAP continue" },
  { "<leader>dr",  function() require 'dap'.restart_frame() end,                                "DAP restart frame" },
  { "<leader>dn",  ":DapNew<cr>",                                                               "DAP new session" },
  { 'K',           vim.lsp.buf.hover,                                                           'Hover Documentation' },
  { '<C-k>',       vim.lsp.buf.signature_help,                                                  'Signature Documentation' },

  { 'gD',          vim.lsp.buf.declaration,                                                     '[G]oto [D]eclaration' },
  { 'gR',          vim.lsp.buf.references,                                                      '[G]oto [R]eferences in current buffer' },
  { '<leader>wa',  vim.lsp.buf.add_workspace_folder,                                            '[W]orkspace [A]dd Folder' },
  { '<leader>wr',  vim.lsp.buf.remove_workspace_folder,                                         '[W]orkspace [R]emove Folder' },
  { '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders' },
}

return {
  lspBuffKeymaps = lspBuffKeymaps
}
