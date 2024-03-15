return {
  -- Toggle join
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>mj", "<cmd>TSJToggle<cr>", desc = "Toggle Treesitter Join" },
    },
    cmd = { "TSJToggle", "TSJSpliut", "TSJoin" },
    opts = { use_default_keymaps = false },
    -- Remap Bufferline keys
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      {
        "<leader>bl",
        "<cmd>BufferLinePick<cr>",
        "Pick buffer from list",
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.top_down = false
    end,
  },
  -- Auto Dark mode
  {
    "f-person/auto-dark-mode.nvim",
    config = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.cmd("colorscheme catppuccin-frappe")
        vim.api.nvim_set_option("background", "dark")
      end,
      set_light_mode = function()
        vim.cmd("colorscheme catppuccin-latte")
        vim.api.nvim_set_option("background", "light")
      end,
    },
  },
  -- Tmux Navigator
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  { "folke/todo-comments.nvim" },
}
