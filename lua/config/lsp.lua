local servers = require("utils.lspservers")
local on_attach = require("utils.common")

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- require('mason-tool-installer').setup({
--   -- Install these linters, formatters, debuggers automatically
--   ensure_installed = {
--     'java-debug-adapter',
--     'java-test',
--   },
-- })

-- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
-- vim.api.nvim_command('MasonToolsInstall')

-- nvim-cmp supports additional completion capabilitieus, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers.servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    if server_name ~= "jdtls" then
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers.servers[server_name],
        filetypes = (servers.servers[server_name] or {}).filetypes,
      }
    end
  end,

}

local cfg = require("yaml-companion").setup(servers.extra.yaml_cmpanion)
require("lspconfig")["yamlls"].setup(cfg)
