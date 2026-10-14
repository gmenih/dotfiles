return {
  -- LazyVim defaults that only pay off when writing code by hand
  { "akinsho/bufferline.nvim", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "folke/persistence.nvim", enabled = false },
  { "folke/trouble.nvim", enabled = false },
  { "MagicDuck/grug-far.nvim", enabled = false },
  { "nvim-mini/mini.pairs", enabled = false },
  { "windwp/nvim-ts-autotag", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
  { "mfussenegger/nvim-lint", enabled = false },

  -- Free up <leader>n so it is a pure prefix for <leader>ng (Neogit) with no
  -- timeoutlen race against LazyVim's notification history mapping.
  {
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>n", false },
      { "<leader>N", function()
        if Snacks.config.picker and Snacks.config.picker.enabled then
          Snacks.picker.notifications()
        else
          Snacks.notifier.show_history()
        end
      end, desc = "Notification History" },
    },
  },

  -- Move notify to bottom so it doesnt cover NeoTree; render images inline
  -- (needs herdr experimental.kitty_graphics = true and ImageMagick installed)
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        top_down = false,
      },
      image = {
        enabled = true,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {},
  },
  -- Auto Dark mode
  {
    "f-person/auto-dark-mode.nvim",
    config = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.cmd("colorscheme catppuccin-macchiato")
      end,
      set_light_mode = function()
        vim.cmd("colorscheme catppuccin-latte")
      end,
    },
  },
  -- Annotate code and send the comments to the Claude pane in the same tab
  -- (<leader>ac comment, <leader>as send, <leader>aS send and submit)
  { "ChmaraX/herdr-nvim", opts = {} },

  -- Neogit diffs keep syntax colors (treesitter_diff_highlight) over faint
  -- add/delete tints; the hunk under the cursor gets a stronger tint
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      custom_highlights = function(c)
        local tint = require("catppuccin.utils.colors").darken
        return {
          NeogitDiffAdd = { fg = c.none, bg = tint(c.green, 0.1, c.base) },
          NeogitDiffDelete = { fg = c.none, bg = tint(c.red, 0.1, c.base) },
          NeogitDiffAddHighlight = { fg = c.none, bg = tint(c.green, 0.2, c.base) },
          NeogitDiffDeleteHighlight = { fg = c.none, bg = tint(c.red, 0.2, c.base) },
          NeogitDiffContextHighlight = { bg = c.surface0 },
        }
      end,
    },
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>ng", "<cmd>Neogit<cr>", desc = "Open NeoGit" },
    },
    opts = {
      commit_view = { kind = "tab" },
      treesitter_diff_highlight = true,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gv",
        function()
          if require("diffview.lib").get_current_view() then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Toggle Diffview (working tree)",
      },
    },
  },

  -- NeoTree on the right
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "right"
    end,
  },
}
