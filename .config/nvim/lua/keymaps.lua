-- Keymaps for clipboard interaction
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>p', [["+p]])
vim.keymap.set('v', '<leader>P', [["_dP]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- Extra save commands because of fat-finger
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Wa', 'wa', {})
vim.api.nvim_create_user_command('Wqa', 'wqa', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- kubernetes secrets
vim.keymap.set('n', 'sen', "<cmd>%!yq -e '.data = (.data | withEntries(.value = (.value | @base64)))'<cr>", { desc = 'Encrypt k8s base64 keys' })

vim.keymap.set('n', 'sde', "<cmd>%!yq -e '.data = (.data | withEntries(.value = (.value | @base64d)))'<cr>", { desc = 'Decrypt k8s base64 keys' })

vim.keymap.set('n', '<Tab>', '>>')
vim.keymap.set('n', '<S-Tab>', '<<')
vim.keymap.set('v', '<Tab>', '>><Esc>gv')
vim.keymap.set('v', '<S-Tab>', '<<<Esc>gv')
