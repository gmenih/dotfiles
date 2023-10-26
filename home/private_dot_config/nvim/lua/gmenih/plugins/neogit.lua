return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "nvim-telescope/telescope.nvim", -- optional
        "sindrets/diffview.nvim", -- optional
        "ibhagwan/fzf-lua", -- optional
    },
    config = function()
        require("neogit").setup()
        require("which-key").register({
            ["<leader>ng"] = { "<cmd>Neogit<CR>", "Open Neogit" },
        })
    end,
}
