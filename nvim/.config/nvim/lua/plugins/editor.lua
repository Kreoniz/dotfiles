return {
  'tpope/vim-sleuth',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      spec = {
        { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
        { '<leader>d', group = 'Document' },
        { '<leader>r', group = 'Rename' },
        { '<leader>f', group = 'Find' },
        { '<leader>w', group = 'Workspace' },
        { '<leader>t', group = 'Toggle' },
      },
    },
  },
  {
    'luisiacc/gruvbox-baby',
    priority = 1000,
    config = function()
      vim.g.gruvbox_baby_transparent_mode = 1
      vim.cmd.colorscheme 'gruvbox-baby'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      scss = { css = true, css_fn = true },
      css = { css = true, css_fn = true, rgb_fn = true },
      vue = { css = true, css_fn = true, rgb_fn = true },
      html = { rgb_fn = true },
    },
  },
}
