return {
    {
        "ellisonleao/gruvbox.nvim",
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.o.background = "dark" -- or "light" for light mode
            vim.cmd([[colorscheme gruvbox]])
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        options = {
            theme = "gruvbox"
        }
    }
}
