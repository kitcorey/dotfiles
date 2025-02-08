-- This file can be loaded by calling `lua require('plugins')` from your init.vim

require("packer").startup(function(use)
  -- Packer can manage itself
    use("wbthomason/packer.nvim")
    use {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup{}
            vim.o.background = "dark" -- or "light" for light mode
            vim.cmd([[colorscheme gruvbox]])
        end
    }
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require('lspconfig').clangd.setup{
                cmd = { 'clangd' }
            --         'cclangd',
            --         'iadp_test',
            --     },
            }
            require'lspconfig'.pyright.setup{
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
            }
            require'lspconfig'.ruff.setup{}
            require'lspconfig'.ruby_lsp.setup{}
            require'lspconfig'.rubocop.setup{}
            -- require'lspconfig'.solargraph.setup{}
        end
    }
    use {
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        config = function()
            require('toggle_lsp_diagnostics').init()
        end
    }
    use {
        "akinsho/toggleterm.nvim",
        tag = '*',
        config = function()
            require("toggleterm").setup{}
        end
    }
    -- use {
    --     "folke/which-key.nvim",
    --     config = function()
    --         vim.o.timeout = true
    --         vim.o.timeoutlen = 300
    --         require("which-key").setup {
    --       }
    --     end
    -- }
    use {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require('treesitter-context').setup {
                max_lines = 5
            }
        end,
        requires = {
            {"nvim-treesitter/nvim-treesitter"}
        }
    }
    use {
        "ThePrimeagen/refactoring.nvim",
        config = function()
            require('refactoring').setup({})
        end,
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    }
	-- use {
	--     "kndndrj/nvim-dbee",
	--     requires = {
	-- 	    "MunifTanjim/nui.nvim",
	--     },
	--     run = function()
	--         -- Install tries to automatically detect the install method.
	--         -- if it fails, try calling it with one of these parameters:
	--         --    "curl", "wget", "bitsadmin", "go"
	--         require("dbee").install()
	--     end,
	--     config = function()
	--         require("dbee").setup {
	--         	sources = {
    --         		require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS")
    --             }
    --         }
	--     end
	-- }
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup()
        end
    }
    use {
        "ibhagwan/fzf-lua",
        requires = {
            -- optional for icon support
            "nvim-tree/nvim-web-devicons"
        },
	    config = function()
	        require("fzf-lua").setup {
                "default",
                winopts = {
                    preview = {
                        hidden = false,
                        default = "bat"
                    }
                },
                previewers = {
                    bat = {
                        args = "--color=always --style=numbers,changes --theme=gruvbox-dark"
                    }
                }
            }
            vim.keymap.set('n', '<C-p>', require('fzf-lua').files)
            vim.keymap.set('n', '<space>/', require('fzf-lua').grep)
            vim.keymap.set('n', '<space>b', require('fzf-lua').buffers)
	    end
    }
end)

