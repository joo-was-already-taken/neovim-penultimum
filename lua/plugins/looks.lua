return {
  {
    "noice.nvim",
    lazy = false,
    after = function(_)
      require("noice").setup({
        lsp = {
          progress = { enabled = false },
        },
      })
    end,
  },
  {
    "nvim-notify",
    lazy = false,
    after = function(_)
      local notify = require("notify")
      notify.setup({
        render = "compact",
        top_down = false,
      })

      vim.cmd.highlight("link NotifyBackground NormalFloat")

      local function dismiss_notifications()
        notify.dismiss({ silent = true, padding = true })
      end
      require("utils").keymap_set("n", "<leader>cn", dismiss_notifications)
    end,
  },
}
