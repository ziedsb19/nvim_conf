return {
	{
		"3rd/image.nvim",
		enabled = false,
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					only_render_image_at_cursor_mode = "popup", -- or "inline"
					floating_windows = false, -- if true, images will be rendered in floating markdown windows
					filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
				},
				asciidoc = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					only_render_image_at_cursor_mode = "popup",
					floating_windows = false,
					filetypes = { "asciidoc", "adoc" },
				},
				neorg = {
					enabled = true,
					filetypes = { "norg" },
				},
				rst = {
					enabled = true,
				},
				typst = {
					enabled = true,
					filetypes = { "typst" },
				},
				html = {
					enabled = false,
				},
				css = {
					enabled = false,
				},
			},
			max_width = 100,     -- tweak to preference
			max_height = 12,     -- ^
			max_height_window_percentage = math.huge, -- this is necessary for a good experience
			max_width_window_percentage = math.huge,
			window_overlap_clear_enabled = true,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			scale_factor = 1.0,
			editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
			tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		}
	}
}
