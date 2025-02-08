return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        vim.keymap.set('n', '<C-n>', require('nvim-tree.api').tree.toggle)
    end,
}
