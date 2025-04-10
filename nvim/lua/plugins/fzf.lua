return {
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            -- optional for icon support
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            "default",
            winopts = {
                fullscreen = true,
                preview = {
                    hidden = false,
                    default = "bat",
                    flip_columns   = 150 -- #cols to switch to horizontal on flex
                }
            },
            previewers = {
                bat = {
                    args = "--color=always --style=numbers,changes --theme=gruvbox-dark"
                }
            }
        },
        config = function(_, opts)
            require("fzf-lua").setup(opts)
            vim.keymap.set('n', '<C-p>', require('fzf-lua').files)
            vim.keymap.set('n', '<space>/', require('fzf-lua').grep)
            vim.keymap.set('n', '<space>b', require('fzf-lua').buffers)
        end
    }
}
