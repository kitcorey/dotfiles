return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            ignore_focus = { "NvimTree" },
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
            },
            winbar = {
              lualine_a = {},
              lualine_b = {
                {
                  'filename',
                  path = 1,  -- Show relative path
                  file_status = true,  -- Shows file status (readonly, modified)
                  symbols = {
                    modified = ' ●',  -- Text to show when file is modified
                    readonly = ' ',  -- Text to show when file is readonly
                    unnamed = '[No Name]',  -- Text to show for unnamed buffers
                  }
                }
              },
              lualine_c = {'branch'},
              lualine_x = {'diagnostics'},
              lualine_y = {'filetype'},
              lualine_z = {'location'}
            },
            inactive_winbar = {
              lualine_a = {},
              lualine_b = {
                {
                  'filename',
                  path = 1,
                  file_status = true,
                  symbols = {
                    modified = ' ●',
                    readonly = ' ',
                    unnamed = '[No Name]',
                  }
                }
              },
              lualine_c = {},
              lualine_x = {'location'},
              lualine_y = {},
              lualine_z = {}
            },
            options = {
                theme = 'auto',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                  winbar = {'dashboard', 'NvimTree', 'Outline', 'alpha'},
                },
                globalstatus = true,  -- Use global statusline
            },
        },
        config = function(_, opts)
            require("lualine").setup(opts)
        end
    }
}
