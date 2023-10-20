-- https://github.com/lewis6991/gitsigns.nvim
-- KeyBindings:
-- hs - stage hunk
-- hr - reset hunk
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Git Next hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Git Prev hunk" })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Git Stage hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Git Reset hunk" })
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Git Stage hunk" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Git Reset hunk" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Git Stage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Git Undo stage hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Git Reset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Git Preview hunk" })
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, { desc = "Git Blame line" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Git Toggle current line blame" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Git Diff this" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "Git Diff this" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "Git Toggle deleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git Select hunk" })
            end,
        })
    end,
}
