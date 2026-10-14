-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Agents edit files behind nvim's back; poll so open buffers reload without
-- waiting for a focus event.
vim.fn.timer_start(1000, function()
  if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
    vim.cmd("silent! checktime")
  end
end, { ["repeat"] = -1 })

-- Downscale oversized PNGs before snacks.image sends them (herdr size limits).
LazyVim.on_load("snacks.nvim", function()
  require("config.image_downscale").setup()
end)
