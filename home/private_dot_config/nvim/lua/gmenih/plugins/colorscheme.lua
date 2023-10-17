-- Use catppuccin theme (latte by daye, mocha by night)
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
                transparent_background = true,
            })

            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
