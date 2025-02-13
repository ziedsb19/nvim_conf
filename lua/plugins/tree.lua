return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del("n", "<Tab>", { buffer = bufnr })

        -- custom mappings
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
      end
      ,
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        enable = false,
        git_ignored = false,
        dotfiles = false
      }
    }
  },
}
