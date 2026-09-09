-- Languages installed by treesitter.
-- On the `main` branch there is no `ensure_installed` option, so we install
-- the missing parsers ourselves in `config`.
local ensure_installed = {
  'bash',
  'c',
  'cpp',
  'go',
  'java',
  'javascript',
  'json',
  'lua',
  'python',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

-- `main` dropped the built-in incremental selection module, so we keep a very
-- small version of it here. `stack` holds the nodes we already selected, so
-- node_decremental can walk back.
local incremental = {}
do
  local stack = {}
  local stack_buf = nil

  -- Put the visual selection on the given node.
  local function select_node(node)
    local srow, scol, erow, ecol = node:range()
    if vim.fn.mode():match('[vV\22]') then
      vim.cmd('normal! \27')
    end
    vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
    vim.cmd('normal! v')
    -- `end_col` is exclusive: a value of 0 means the node stops at the end of
    -- the line above.
    if ecol == 0 then
      erow = erow - 1
      ecol = #vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1]
    end
    vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
  end

  local function same_range(a, b)
    local a1, a2, a3, a4 = a:range()
    local b1, b2, b3, b4 = b:range()
    return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
  end

  function incremental.init()
    local node = vim.treesitter.get_node()
    if not node then
      return
    end
    stack = { node }
    stack_buf = vim.api.nvim_get_current_buf()
    select_node(node)
  end

  function incremental.increment()
    -- The nodes belong to one buffer, so start over in another buffer.
    if stack_buf ~= vim.api.nvim_get_current_buf() then
      return incremental.init()
    end
    local node = stack[#stack]
    if not node then
      return incremental.init()
    end
    -- Skip parents that cover exactly the same text, else nothing seems to grow.
    local parent = node:parent()
    while parent and same_range(parent, node) do
      parent = parent:parent()
    end
    if parent then
      table.insert(stack, parent)
      node = parent
    end
    select_node(node)
  end

  function incremental.decrement()
    if stack_buf ~= vim.api.nvim_get_current_buf() then
      return
    end
    if #stack > 1 then
      table.remove(stack)
    end
    local node = stack[#stack]
    if node then
      select_node(node)
    end
  end
end

return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup {
        -- Parsers and queries go to `stdpath('data')/site` by default.
        install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site'),
      }

      -- Install only what is missing, so startup stays fast.
      local installed = ts.get_installed('parsers')
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #missing > 0 then
        ts.install(missing)
      end

      -- On `main` nothing is enabled automatically. We start the parser and set
      -- the indent expression per buffer.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          -- `language.add` returns nil when the parser is not installed.
          if not lang or not vim.treesitter.language.add(lang) then
            return
          end
          vim.treesitter.start(args.buf, lang)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- incremental selection (same keys as before)
      vim.keymap.set('n', '<c-space>', incremental.init, { desc = 'Init selection' })
      vim.keymap.set('x', '<c-space>', incremental.increment, { desc = 'Increment node' })
      vim.keymap.set('x', '<M-space>', incremental.decrement, { desc = 'Decrement node' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        move = {
          -- whether to set jumps in the jumplist
          set_jumps = true,
        },
      }

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      -- On `main` every keymap is set by the user, not by the plugin.
      -- The capture groups come from textobjects.scm.
      local selections = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
      }
      for key, query in pairs(selections) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = 'Select ' .. query })
      end

      local moves = {
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
          [']l'] = '@loop.outer',
          [']i'] = '@conditional.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
          [']L'] = '@loop.outer',
          [']I'] = '@conditional.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
          ['[l'] = '@loop.outer',
          ['[i'] = '@conditional.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
          ['[L'] = '@loop.outer',
          ['[I'] = '@conditional.outer',
        },
      }
      for direction, keys in pairs(moves) do
        for key, query in pairs(keys) do
          vim.keymap.set({ 'n', 'x', 'o' }, key, function()
            move[direction](query, 'textobjects')
          end, { desc = direction .. ' ' .. query })
        end
      end

      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next('@parameter.inner')
      end, { desc = 'Swap next parameter' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous('@parameter.inner')
      end, { desc = 'Swap previous parameter' })
    end,
  },
}
