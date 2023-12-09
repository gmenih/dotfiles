-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

keymap.set("i", "<esc><esc>", "<esc>:w<CR>", { desc = "Save file and exit insert mode" })
-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
-- opposite of u = shift+u
keymap.set("n", "U", ":redo<CR>", { desc = "Redo" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
-- keymap.set("n", "<leader>tl", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
-- keymap.set("n", "<leader>th", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Light/Dark mode
keymap.set("n", "<leader>bw", "<cmd>:set bg=dark<CR>", { desc = "Set background to dark" })
keymap.set("n", "<leader>be", "<cmd>:set bg=light<CR>", { desc = "Set background to light" })

-- Buffer stuff
keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Go to next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Go to previous buffer" })

-- Keep visual selection when indenting
keymap.set("x", ">", ">gv", { desc = "Indent selection" })
keymap.set("x", "<", "<gv", { desc = "Unindent selection" })
