require('plugins')

local toggle_lsp_client = function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  if not vim.tbl_isempty(clients) then
    vim.cmd("LspStop")
  else
    vim.cmd("LspStart")
  end
end
vim.keymap.set('n', '<leader>lt', toggle_lsp_client)

local lspconfig = require('lspconfig')

-- Notably _not_ including `compile_commands.json`, as we want the entire project
local root_pattern = lspconfig.util.root_pattern('.git')

-- Might be cleaner to try to expose this as a pattern from `lspconfig.util`, as
-- really it is just stolen from part of the `clangd` config
local function project_name_to_container_name()
    -- Turn the name of the current file into the name of an expected container, assuming that
    -- the container running/building this file is named the same as the basename of the project
    -- that the file is in
    --
    -- The name of the current buffer
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Turned into a filename
    local filename = lspconfig.util.path.is_absolute(bufname) and bufname or lspconfig.util.path.join(vim.loop.cwd(), bufname)

    -- Then the directory of the project
    local project_dirname = root_pattern(filename) or lspconfig.util.path.dirname(filename)

    -- And finally perform what is essentially a `basename` on this directory
    print(vim.fn.fnamemodify(lspconfig.util.find_git_ancestor(project_dirname), ':t'))
    return vim.fn.fnamemodify(lspconfig.util.find_git_ancestor(project_dirname), ':t')
end
vim.keymap.set('n', '<leader>lp', toggle_lsp_client)

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = { "lua" },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
    ensure_installed = { "python", "ruby", "yaml" }
  },
}

-- vim.lsp.set_log_level("debug")

-- vim.keymap.set('n', '<leader>tld', toggle-lsp-diag)

-- Show source of diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})
