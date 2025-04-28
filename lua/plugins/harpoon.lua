return {
	{
		"ThePrimeagen/harpoon",

		keys = {
			{ "<leader>bm", ":lua require('harpoon.mark').add_file() <CR>",        desc = "Mark buffer" },
			{ "<leader>bs", ":lua require('harpoon.ui').toggle_quick_menu() <CR>", desc = "Show Marked Buffers" },
		},
	}
}
