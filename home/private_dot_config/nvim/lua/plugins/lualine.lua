return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus
    local Util = require("lazyvim.util")
    return {
      options = {
        theme = "auto",
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          { "mode", upper = true },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.ui.fg("Constant")
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.ui.fg("Debug")
            },
        },
        lualine_y = {
          { "filetype" },
          { "diff" },
        },
        lualine_z = {
          { "branch" },
        },
      },
      extensions = { "neo-tree", "lazy" },
    }
  end,
}
