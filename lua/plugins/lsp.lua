return {
  {
    "nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    before = function()
      require("lz.n").trigger_load("blink.cmp")
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
          settings = {
            Lua = {
              diagnostics = {
                workspaceDiagnostics = true,
                neededFileStatus = {
                  ["codestyle-check"] = "Any",
                  ["fallback"] = "Any",
                },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
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
      }
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
