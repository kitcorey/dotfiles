return {
    {
        "neovim/nvim-lspconfig",
        config = function(_, opts)
            vim.lsp.config("clangd", {
                cmd = { 'clangd' }
            --         'cclangd',
            --         'iadp_test',
            --     },
            })
            vim.lsp.config("pyright", {
                -- Disable "help" diagnostics
                -- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1439132189
                capabilities = (function()
                    local capabilities = vim.lsp.protocol.make_client_capabilities()
                    capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
                    return capabilities
                end)(),
                settings = {
                    python = {
                        pythonPath = vim.fn.exepath("python"),
                    },
                },
            })
            vim.lsp.config("ruff", {})
            vim.lsp.config("ruby_lsp", {})
            vim.lsp.config("rubocop", {})
            vim.lsp.config("rubocop", {})
            vim.lsp.config("gopls", {})
            -- vim.lsp.config("solargraph", {})
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local parsers = { "python", "ruby", "yaml", "go" }
            local install_dir = vim.fn.stdpath("data") .. "/site"

            -- lazy.nvim resets the default runtimepath, so the install dir
            -- (where install() drops parser/*.so and queries/) is not picked
            -- up automatically. Prepend it before setup() so :checkhealth and
            -- vim.treesitter.language.add() can find installed parsers.
            vim.opt.rtp:prepend(install_dir)

            require("nvim-treesitter").setup({ install_dir = install_dir })
            require("nvim-treesitter").install(parsers)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("UserTSStart", { clear = true }),
                pattern = parsers,
                callback = function(ev)
                    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
                    if lang and pcall(vim.treesitter.language.add, lang) then
                        vim.treesitter.start(ev.buf, lang)
                    end
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "VeryLazy",
        config = function()
            require("treesitter-context").setup({ max_lines = 5 })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {}
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = { "lewis6991/async.nvim" },
        lazy = false,
        config = function()
            require("refactoring").setup()
        end,
    }
}
