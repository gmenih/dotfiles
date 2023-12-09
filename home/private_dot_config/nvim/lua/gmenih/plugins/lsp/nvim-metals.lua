return {
    "scalameta/nvim-metals", -- configure formatters & linters
    lazy = true,
    -- event = { "BufReadPre", "BufNewFile" }, -- to enable uncomment this
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = function()
        return require("metals").bare_config()
    end,
}
