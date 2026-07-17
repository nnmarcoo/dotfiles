vim.g.mapleader = " "
vim.keymap.set('n', '<leader>cd', vim.cmd.Ex)

vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')

vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"+d', { desc = 'Delete to system clipboard' })

vim.keymap.set('n', '<leader>e', ':e<CR>')


