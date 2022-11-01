vim.api.nvim_set_keymap(
    'n',
    '<leader>f',
    ':FZF<cr>',
    { noremap = true }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>p',
    string.format(':!python %s<CR>', vim.fn.expand('%:p')),
    { noremap = true }
)
