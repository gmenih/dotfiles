-- Bufferline adds tabs to top of screen
-- TODO: learn more about it
return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",
                separator_style = "thick",
            },
        })

        require("which-key").register({
            ["<leader>"] = {
                bl = { "<cmd>:BufferLinePick<CR>", "Pick buffer from list" },
                bn = { "<cmd>:BufferLineCycleNext<CR>", "Go to next buffer" },
                bp = { "<cmd>:BufferLineCyclePrev<CR>", "Go to previous buffer" },
                bx = { "<cmd>:BufferLineCloseOther<Cr>", "Close all other buffers" },
            },
        })
    end,
}
