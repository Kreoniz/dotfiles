-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'norcalli/nvim-colorizer.lua',
  event = { 'BufReadPre', 'BufNewFile' }, -- Load on specific events
  config = function()
    require('colorizer').setup {
      scss = { css = true, css_fn = true },
      css = { css = true, css_fn = true, rgb_fn = true },
      html = { rgb_fn = true },
    }
  end,
}
