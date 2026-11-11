return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = { library = { { path = 'luvit-meta/library', words = { 'vim%.uv' } } } },
    dependencies = { { 'Bilal2453/luvit-meta', lazy = true } },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })
      local servers = {
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
        svelte = {},
        gopls = {},
        cssls = {},
        html = {},
        emmet_ls = {},
        eslint = {},
        vue_ls = {},
        ts_ls = {},
        jdtls = {
          -- Keep the server JDK independent of a project's Java version.
          cmd = function(dispatchers, config)
            local workspace = vim.fn.stdpath 'cache' .. '/jdtls/' .. vim.fn.sha256(config.root_dir or vim.uv.cwd())
            return vim.lsp.rpc.start({ 'mise', 'exec', 'java@openjdk-27', '--', 'jdtls', '-data', workspace }, dispatchers, {
              cwd = config.cmd_cwd,
              env = config.cmd_env,
              detached = config.detached,
            })
          end,
        },
      }
      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
      end
      require('config.typescript').setup()

      -- An installed server is not necessarily one we want to enable.
      require('mason-lspconfig').setup { automatic_enable = false }
      local tools = vim.tbl_keys(servers)
      table.insert(tools, 'stylua')
      require('mason-tool-installer').setup { ensure_installed = tools }
      vim.lsp.enable(vim.tbl_keys(servers))
      vim.lsp.enable 'ts_rust'

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local builtin = require 'telescope.builtin'
          local function map(keys, action, desc, mode)
            vim.keymap.set(mode or 'n', keys, action, { buffer = event.buf, desc = desc })
          end
          map('gd', builtin.lsp_definitions, 'Go to definition')
          map('gr', builtin.lsp_references, 'Go to references')
          map('gI', builtin.lsp_implementations, 'Go to implementation')
          map('gD', vim.lsp.buf.declaration, 'Go to declaration')
          map('<leader>D', builtin.lsp_type_definitions, 'Type definition')
          map('<leader>ds', builtin.lsp_document_symbols, 'Document symbols')
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method 'textDocument/inlayHint' then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
            end, 'Toggle inlay hints')
          end
          if client and client:supports_method 'textDocument/documentHighlight' then
            local group = vim.api.nvim_create_augroup('lsp-highlight-' .. event.buf, { clear = true })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              group = group,
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'LspDetach' }, {
              group = group,
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
