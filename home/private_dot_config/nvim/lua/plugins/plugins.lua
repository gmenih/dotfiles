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
  -- Tmux + herdr Navigator
  -- <c-h/j/k/l> come from vim-herdr-navigation, which crosses into herdr panes
  -- at a split edge and falls back to TmuxNavigate* when running under tmux.
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    -- <C-h/j/k/l> are mapped in lua/config/keymaps.lua so they load after
    -- LazyVim's VeryLazy window keymaps instead of being overwritten by them.
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
    opts = {},
  },

  -- NeoTree on the right
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "right"
    end,
  },
}
