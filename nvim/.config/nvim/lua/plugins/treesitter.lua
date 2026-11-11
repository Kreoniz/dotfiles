return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local languages = {
        'bash',
        'c',
        'css',
        'diff',
        'html',
        'java',
        'javascript',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'svelte',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
      }
      local treesitter = require 'nvim-treesitter'
      treesitter.install(languages)
      local enabled = {}
      for _, language in ipairs(languages) do
        enabled[language] = true
      end
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
        callback = function(event)
          local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if enabled[language] and pcall(vim.treesitter.start, event.buf, language) then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
