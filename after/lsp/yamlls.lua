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



return require("yaml-companion").setup(extra.yaml_cmpanion)
