return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    keys = {
      "<leader>aj",
      "<cmd>CopilotChatFixCalendarTest<CR>", -- Fix stupid tests
      desc = "Fix calendar tests",
      mode = { "n", "v" },
    },
    opts = function(_, opts)
      opts.debug = true
    end,
  },
}
