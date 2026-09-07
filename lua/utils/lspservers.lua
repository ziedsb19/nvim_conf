local servers = {
  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp" }, -- explicitly omitting .prot
  },
  -- gopls = {},
  -- protols = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  pyright = {},
  helm_ls = {
    ['helm-ls'] = {
      yamlls = {
        path = "yaml-language-server",
      }
    }
  },


  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

return { servers = servers }
