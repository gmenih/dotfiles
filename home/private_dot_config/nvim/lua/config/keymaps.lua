-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del

map("n", "U", ":redo<CR>", { desc = "Redo" })

-- Annoying bug with TMUX
del("n", "<A-j>")
del("n", "<A-k>")
del("i", "<A-j>")
del("i", "<A-k>")
del("v", "<A-j>")
del("v", "<A-k>")

-- herdr/vim pane navigation on <C-h/j/k/l>. Loaded here, not in the plugin
-- spec, because LazyVim sets its own window keymaps on VeryLazy and would
-- otherwise overwrite these. Falls back to tmux when not inside a herdr pane.
local herdr_nav = vim.fn.glob("~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua", false, true)
if #herdr_nav > 0 then
  dofile(herdr_nav[1])
end
