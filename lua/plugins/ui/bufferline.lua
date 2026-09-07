return {
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
            { "<C-S-t>",    "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
            { "<C-t>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
            { "[b",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
            { "]b",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
        },
        opts = {
            options = {

                diagnostics = "nvim_lsp",
                show_buffer_icons = true,
                -- separator_style = "slope",
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end,
            }
        },
        config = function(_, opts)
            require("bufferline").setup(opts)
        end,
    }
}
