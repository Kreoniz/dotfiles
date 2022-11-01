-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorschemes
  use 'gruvbox-community/gruvbox'
  vim.cmd('colorscheme gruvbox')
  vim.cmd('highlight Normal guibg=none ctermbg=none')
  
  use 'tpope/vim-vinegar'
  use 'tpope/vim-surround'
  use 'junegunn/fzf'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- Snippet engine
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'psf/black'

  use 'dense-analysis/ale'
end)
