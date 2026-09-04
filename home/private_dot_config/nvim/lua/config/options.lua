-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
local opt = vim.opt

opt.shellcmdflag = "-ic"

-- snacks.image identifies the terminal through an async XTVERSION round trip,
-- which herdr answers on libghostty's behalf. Pin detection to TERM_PROGRAM
-- (set by Ghostty, preserved by herdr) so it never depends on that reply.
if vim.env.TERM_PROGRAM == "ghostty" then
  vim.env.SNACKS_GHOSTTY = "1"
end
