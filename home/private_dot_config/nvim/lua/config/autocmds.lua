-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Downscale oversized PNGs before snacks.image sends them (herdr size limits).
LazyVim.on_load("snacks.nvim", function()
  require("config.image_downscale").setup()
end)
