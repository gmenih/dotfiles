-- Bufferline adds tabs to top of screen
-- TODO: learn more about it
return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = "tabs",
            separator_style = "thick",
        },
    },
}
