vim.keymap.set("n", "-", vim.cmd.Ex)

vim.cmd('nnoremap <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>')
-- vim.cmd('nnoremap "<C-d>", "<C-d>zz"')
-- vim.cmd('nnoremap "<C-u>", "<C-u>zz"')
