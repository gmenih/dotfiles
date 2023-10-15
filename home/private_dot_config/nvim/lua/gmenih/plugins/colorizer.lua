-- This plugin add colors to strings containing hex colors (or words, like blue)
return {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
}
