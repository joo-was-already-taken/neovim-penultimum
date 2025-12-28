return {
  {
    "noice",
    lazy = false,
    after = function(_)
      require("noice").setup({})
    end,
  },
  {
    "notify",
    lazy = false,
    after = function(_)
      local notify = require("notify")
      notify.setup({
        render = "compact",
        top_down = false,
      })

      local function dismiss_notifications()
        notify.dismiss({ silent = true, padding = true })
      end
      require("utils").keymap_set("n", "<leader>cn", dismiss_notifications)
    end,
  },
}
