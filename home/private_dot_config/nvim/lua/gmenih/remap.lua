vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

function ca_db()
	vim.api.nvim_feedkeys('da{', 'n', false)
	vim.api.nvim_feedkeys('ca{', 'n', false)
end

vim.keymap.set('n', '<leader>ca{', ca_db)

