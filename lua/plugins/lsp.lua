local is_nvim_dev_on = false

vim.api.nvim_create_user_command("NvimDev", function(opts)
  local arg = opts.args
  if arg == "start" then
    is_nvim_dev_on = true
  elseif arg == "stop" then
    is_nvim_dev_on = false
  else
    vim.notify("NvimDev: expected 'start' or 'stop'", vim.log.levels.ERROR)
    return
  end
  for _, client in ipairs(vim.lsp.get_clients({ name = "lua_ls" })) do
    ---@diagnostic disable-next-line: undefined-field
    client.config.settings.Lua.workspace.library =
      is_nvim_dev_on and vim.api.nvim_get_runtime_file("", true) or {}
    client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end
  vim.notify("NvimDev: " .. arg, vim.log.levels.INFO)
end, {
  nargs = 1,
  complete = function()
    return { "start", "stop" }
  end,
  desc = "Toggle Neovim Lua dev environment for lua_ls",
})

local plugins = {
  {
    "nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    before = function()
      require("lz.n").trigger_load("blink.cmp")
      if vim.g.allow_downloads then
        require("lz.n").trigger_load("mason.nvim")
        require("lz.n").trigger_load("mason-lspconfig.nvim")
      end
    end,
    after = function(_)
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local servers = {
        lua_ls = {
          on_init = function(client)
            client.config.settings.Lua.workspace.library =
              is_nvim_dev_on and vim.api.nvim_get_runtime_file("", true) or {}
            client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end,
          settings = {
            Lua = {
              diagnostics = {
                workspaceDiagnostics = true,
                neededFileStatus = {
                  ["codestyle-check"] = "Any",
                  ["fallback"] = "Any",
                },
              },
              workspace = { library = {} },
            },
          },
        },
        nil_ls = {},
        bashls = {},
        pyright = {},
        clangd = {},
        gopls = {},
        rust_analyzer = {},
        zls = {},
        tinymist = {},
        ts_ls = {},
        intelephense = {},
        slint_lsp = {},
      }

      if vim.g.allow_downloads then
        require("mason").setup()
        require("mason-lspconfig").setup()

        vim.api.nvim_create_user_command("MasonInstallAll", function()
          vim.cmd("LspInstall " .. table.concat(vim.tbl_keys(servers), " "))
        end, {})
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })
      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server, true)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspConfig", {}),
        callback = function(ev)
          local function keymap_set(mode, new, prev)
            local opts = { noremap = true, silent = true, buffer = ev.buf }
            vim.keymap.set(mode, new, prev, opts)
          end
          local buf = vim.lsp.buf

          keymap_set("n", "K", buf.hover)
          keymap_set("n", "gd", buf.definition)
          keymap_set("n", "gD", buf.declaration)
          keymap_set("n", "gt", buf.type_definition)
          keymap_set("n", "gr", buf.references)
          keymap_set("n", "gi", buf.implementation)
          keymap_set("n", "<leader>rn", buf.rename)
          keymap_set("n", "<leader>ca", buf.code_action)
          keymap_set("n", "gR", "<cmd>Telescope lsp_references<CR>")
          keymap_set({ "n", "v" }, "<leader>lf", buf.format)

          keymap_set("n", "<leader>xd", "<cmd>Lspsaga show_line_diagnostics<CR>")
          keymap_set("n", "<leader>xj", "<cmd>Lspsaga diagnostic_jump_next<CR>")
          keymap_set("n", "<leader>xk", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
        end,
      })
    end,
  },
  {
    "lspsaga.nvim",
    event = "LspAttach",
    before = function()
      require("lz.n").trigger_load("nvim-treesitter")
    end,
    after = function(_)
      require("lspsaga").setup({
        ui = { code_action = "" },
        symbol_in_winbar = { enable = false },
      })
    end,
  },
  {
    "fidget.nvim",
    event = "LspAttach",
    after = function(_)
      require("fidget").setup({
        progress = {
          suppress_on_insert = true,
          display = {
            render_limit = 12,
          },
        },
      })
    end,
  },
}

if vim.g.allow_downloads then
  table.insert(plugins, { "mason.nvim" })
  table.insert(plugins, { "mason-lspconfig.nvim" })
end

return plugins
