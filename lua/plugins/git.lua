return {
  {
    "conflict",
    lazy = false,
    after = function(_)
      require("conflict").setup({
        default_mappings = true,
        default_commands = true,
      })
    end,
  },
  {
    "gitsigns.nvim",
    lazy = false,
    after = function(_)
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        current_line_blame_opts = {
          delay = 0,
        },
        max_file_length = 100000,

        on_attach = function(bufnr)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "<leader>gb", function()
            gitsigns.blame_line({ full = true })
          end)
          map("n", "<leader>ga", gitsigns.stage_hunk)
          map("n", "<leader>gr", gitsigns.reset_hunk)
          map("v", "<leader>ga", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>gA", gitsigns.stage_buffer)
          map("n", "<leader>gR", gitsigns.reset_buffer)

          map("n", "<leader>gp", gitsigns.preview_hunk)
          map("n", "<leader>gdd", gitsigns.diffthis)
          map("n", "<leader>gD", function() gitsigns.diffthis("~") end)
          map("n", "<leader>gdw", gitsigns.toggle_word_diff)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)
        end,
      })
    end,
  },
}
