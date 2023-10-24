-- Use the catppuccin theme (latte by day, mocha by night)
return {
    {
        "catppuccin/nvim",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                background = {
                    dark = "mocha",
                    light = "latte",
                },
                transparent_background = false,
            })

            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
