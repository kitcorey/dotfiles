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
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require('treesitter-context').setup {
                max_lines = 5
            }
        end,
        requires = {
            {"nvim-treesitter/nvim-treesitter"}
        }
    },
    {
        "lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {}
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, opts)
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                highlight = { enable = true },
                disable = {},
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
                sync_install = false,
                ensure_installed = { "python", "ruby", "yaml", "go" }
                })
        end
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = false,
        config = function()
            require("refactoring").setup()
        end,
    }
}
