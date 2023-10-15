-- https://github.com/lewis6991/gitsigns.nvim
-- KeyBindings:
-- hs - stage hunk
-- hr - reset hunk
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
}
