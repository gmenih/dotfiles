-- Use catppuccin theme (latte by daye, mocha by night)
return {
    {
        "catppuccin/nvim",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme catppuccin-mocha]]) -- dark mode

            -- vim.cmd([[colorscheme catppuccin-latte]]) -- light mode
        end,
    },
}
