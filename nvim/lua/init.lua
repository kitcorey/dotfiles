require("config.lazy")

-- If supported, neovim will change the cursor to a vertical bar in all insert
-- modes.  This is hard to see in iterm2 with smaller fonts, so disable it
vim.opt.guicursor = ""

local toggle_lsp_client = function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = buf })
  if not vim.tbl_isempty(clients) then
    vim.cmd("LspStop")
  else
    vim.cmd("LspStart")
  end
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

-- vim.lsp.set_log_level("debug")

-- Toggle diagnostics for all buffers.  Taken from:
-- https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

-- Show source of diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})

vim.opt.laststatus = 3

-- Mail. aerc compose buffers are *.eml, so neovim's mail ftplugin already sets
-- textwidth=72 and auto-wrap. Add spell check, and with aerc's edit-headers
-- don't auto-wrap header lines: a wrapped To:/Cc: line has no leading space,
-- so aerc would stop reading it as a header. Headers end at the first blank line.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserMail', {}),
  pattern = 'mail',
  callback = function(ev)
    vim.opt_local.spell = true
    vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
      group = vim.api.nvim_create_augroup('UserMailHeaders' .. ev.buf, {}),
      buffer = ev.buf,
      callback = function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local in_headers = false
        if vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1]:match('^[%w-]+:') then
          for i, line in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, row, false)) do
            if line == '' then break end
            if i == row then in_headers = true end
          end
        end
        vim.bo[ev.buf].textwidth = in_headers and 0 or 72
      end,
    })
  end,
})
