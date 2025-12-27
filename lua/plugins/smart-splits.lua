return {
  "smart-splits-nvim",
  after = function(_)
    local splits = require("smart-splits")
    splits.setup({
      default_amount = 5,
    })

    require("hydra")({
      mode = "n",
      body = "<leader>s",
      config = {
        invoke_on_body = true,
      },
      heads = {
        { "-", "<cmd>split<cr>", { exit = true } },
        { "|", "<cmd>vsplit<cr>", { exit = true } },
        { "=", "<C-w>=", { exit = true } },

        { "h", splits.resize_left },
        { "j", splits.resize_down },
        { "k", splits.resize_up },
        { "l", splits.resize_right },

        { "H", splits.swap_buf_left, { exit = true } },
        { "J", splits.swap_buf_down, { exit = true } },
        { "K", splits.swap_buf_up, { exit = true } },
        { "L", splits.swap_buf_right, { exit = true } },
      },
    })
  end,
}
