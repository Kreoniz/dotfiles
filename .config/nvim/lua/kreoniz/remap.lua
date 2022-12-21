vim.keymap.set("n", "-", vim.cmd.Ex)

vim.cmd('nnoremap <leader>cc :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>')
