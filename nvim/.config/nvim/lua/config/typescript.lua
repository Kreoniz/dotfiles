local M = {}

local function vue_project(bufnr, root)
  if vim.bo[bufnr].filetype == 'vue' then
    return true
  end
  for _, directory in ipairs { vim.fs.root(bufnr, 'package.json') or root, root } do
    local file = io.open(directory .. '/package.json', 'r')
    if file then
      local ok, package = pcall(vim.json.decode, file:read '*a')
      file:close()
      if ok and type(package) == 'table' then
        local deps = vim.tbl_extend('force', package.dependencies or {}, package.devDependencies or {}, package.peerDependencies or {})
        if deps.vue or deps.nuxt or deps['@vue/compat'] then
          return true
        end
      end
    end
  end
  return false
end

function M.setup()
  -- Reuse lspconfig's workspace discovery and Deno exclusion for both servers.
  local project_root = vim.lsp.config.ts_ls.root_dir
  local function root_for(vue)
    return function(bufnr, on_dir)
      project_root(bufnr, function(root)
        if vue_project(bufnr, root) == vue then
          on_dir(root)
        end
      end)
    end
  end

  vim.lsp.config('ts_rust', {
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_dir = root_for(false),
    cmd = function(dispatchers, config)
      local local_bin = config.root_dir .. '/node_modules/.bin/tsc-rs'
      local cmd = vim.fn.executable(local_bin) == 1 and { local_bin, '--lsp', '--stdio' }
        or { 'mise', 'exec', 'npm:tsc-rs@0.8.0', '--', 'tsc-rs', '--lsp', '--stdio' }
      return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.root_dir })
    end,
  })

  -- Vue needs its tsserver plugin; use the legacy server only in Vue projects.
  vim.lsp.config('ts_ls', {
    root_dir = root_for(true),
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
          languages = { 'vue' },
        },
      },
    },
  })
end

return M
