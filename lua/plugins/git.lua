return {
  {
    "conflict.nvim",
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
          map("n", "<leader>gD", function()
            gitsigns.diffthis("~")
          end)
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
  {
    "diffview-plus.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewToggle",
      "DiffviewFileHistory",
      "DiffviewDiffFiles",
      "DiffviewLog",
    },
    after = function(_)
      require("diffview").setup({
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          default = { layout = "diff2_horizontal" },
          merge_tool = { layout = "diff3_horizontal" },
        },
        file_panel = {
          listing_style = "tree",
          win_config = { position = "left", width = 35 }, -- Use "auto" to fit content
        },
        hooks = {}, -- See :h diffview-config-hooks
        keymaps = {}, -- See :h diffview-config-keymaps
      })
    end,
  },
}
