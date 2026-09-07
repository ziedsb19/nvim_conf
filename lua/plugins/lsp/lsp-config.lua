return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    config = function()
      require("config.lsp")
    end,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim', opts = {} },
    },
  },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
}
