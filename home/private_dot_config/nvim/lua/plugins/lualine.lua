return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus
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
        lualine_x = {},
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
