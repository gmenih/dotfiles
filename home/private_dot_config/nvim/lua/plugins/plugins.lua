return {
  -- Toggle join
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>mj", "<cmd>TSJToggle<cr>", desc = "Toggle Treesitter Join" },
    },
    cmd = { "TSJToggle", "TSJSpliut", "TSJoin" },
    opts = { use_default_keymaps = false, max_join_length = 512 },
    -- Remap Bufferline keys
  },
  -- Bufferline BL binding
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
  -- Move notify to bottom so it doesnt cover NeoTree
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        top_down = false,
      },
    },
  },
  -- Auto Dark mode
  {
    "f-person/auto-dark-mode.nvim",
    config = {
      update_interval = 5000,
      set_dark_mode = function()
        vim.cmd("colorscheme catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.cmd("colorscheme catppuccin-latte")
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
  -- Neogit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
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
