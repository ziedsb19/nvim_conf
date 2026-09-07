return {
	"ggandor/leap.nvim",
	enabled = false,
	config = function()
		require('leap').create_default_mappings()
	end
}
