return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- Change the Diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- configure html server
        lspconfig["html"].setup({})
        lspconfig["tsserver"].setup({})
        lspconfig["cssls"].setup({})
        lspconfig["tailwindcss"].setup({})
        lspconfig["gopls"].setup({})
        lspconfig["astro"].setup({})
        --
        lspconfig["emmet_ls"].setup({
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "pug" },
        })

        lspconfig["svelte"].setup({
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)

                vim.api.nvim_create_autocmd("BufWritePost", {
                    pattern = { "*.js", "*.ts" },
                    callback = function(ctx)
                        if client.name == "svelte" then
                            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
                        end
                    end,
                })
            end,
        })

        lspconfig["lua_ls"].setup({
            settings = { -- custom settings for lua
                Lua = {
                    -- make the language server recognize "vim" global
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        -- make language server aware of runtime files
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        local on_attach = function(ev)
            local function opts(desc)
                return {
                    noremap = true,
                    silent = true,
                    buffer = ev.buf,
                    desc = desc,
                }
            end
            local keymap = vim.keymap -- for conciseness

            -- set keybinds
            keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts("Show LSP references")) -- show definition, references
            keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration")) -- go to declaration
            keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts("Show LSP definitions")) -- show lsp definitions
            keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts("Show LSP implementations")) -- show lsp implementations
            keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts("Show LSP type definitions")) -- show lsp type definitions
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("See available code actions")) -- see available code actions, in visual mode will apply to selection
            keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Smart rename")) -- smart rename
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts("Show buffer diagnostics")) -- show  diagnostics for file
            keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts("Show line diagnostics")) -- show diagnostics for line
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Go to previous diagnostic")) -- jump to previous diagnostic in buffer
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Go to next diagnostic")) -- jump to next diagnostic in buffer
            keymap.set("n", "K", vim.lsp.buf.hover, opts("Show documentation for what is under cursor")) -- show documentation for what is under cursor
            keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts("Restart LSP")) -- mapping to restart lsp if necessary
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = on_attach,
        })
    end,
}
