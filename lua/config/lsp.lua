local servers = require("utils.lspservers")
local on_attach = require("utils.common")

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require("mason-registry").update()
require('mason-lspconfig').setup()

require('mason-tool-installer').setup({
  -- Install these linters, formatters, debuggers automatically
  ensure_installed = {
    -- 'java-debug-adapter',
    'java-test',
  },
})

vim.api.nvim_command('MasonToolsInstall')

--
-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers.servers)
}

for key, value in pairs(servers.servers) do
  vim.lsp.config(key, {
    on_attach = on_attach,
    settings = value
  })
end
