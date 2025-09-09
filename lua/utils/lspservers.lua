local servers = {
  -- clangd = {},
  gopls = {},
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
  -- yamlls = {
  --   yaml = {
  --     validate = true,
  --     format = { enable = true },
  --     hover = true,
  --     schemaStore = {
  --       enable = true,
  --       url = "https://www.schemastore.org/api/json/catalog.json",
  --     },
  --     schemaDownload = { enable = true },
  --     schemas = {
  --       Kubernetes = "*.yaml",
  --
  --     },
  --     trace = { server = "debug" },
  --   },
  -- },
  -- lua_ls = {
  --   Lua = {
  --     workspace = { checkThirdParty = false },
  --     telemetry = { enable = false },
  --   },
  -- },
}

local extra = {
  yaml_cmpanion = {
    schemas = {
      {
        kubernetes = "*.yaml",
      },
    },
    lspconfig = {
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          schemaStore = {
            enable = true,
            url = "https://www.schemastore.org/api/json/catalog.json",
          },
          schemas = {
            kubernetes = "*.yaml",
          },
        },
      },
    },
  }
}


return { servers = servers, extra = extra }
