return {
    "Wansmer/treesj",
    keys = {
        {
            "<leader>mj",
            "<CMD>TSJToggle<CR>",
            desc = "Toggle Treesitter Join",
        },
    },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    opts = { use_default_keymaps = false },
}
