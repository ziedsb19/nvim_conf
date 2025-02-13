return {
{
	'LukasPietzschmann/telescope-tabs',
	  requires = { 'nvim-telescope/telescope.nvim' },
	  config = function()
		require'telescope-tabs'.setup{

			-- Your custom config :^)
                    entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
	              local entry_string = table.concat( map_file_icon(file_paths), ', ')
	              return string.format('%d: %s%s', tab_id, entry_string, is_current and ' ' or '')
                    end,
                    entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths, is_current)
	              return table.concat(file_names, ' ')
                    end
		}
	end
  }
}
