return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        sections = {
            lualine_c = {
                {
                    "filename",
                    newfile_status = false,  -- Display new file status (new file means no write after created)
                    path = 1       -- 0: Just the filename
                                   -- 1: Relative path
                                   -- 2: Absolute path
                                   -- 3: Absolute path, with tilde as the home directory
                                   -- 4: Filename and parent dir, with tilde as the home directory
                }
            }
        }
    },
    config = function(_, opts)
        require("lualine").setup(opts)
    end
}
