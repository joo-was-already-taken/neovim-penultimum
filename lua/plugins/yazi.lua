return {
  "yazi.nvim",
  keys = {
    { "<leader>yy", "<cmd>Yazi<cr>", mode = { "n", "v" } },
    { "<leader>yd", "<cmd>Yazi cwd<cr>" },
  },
  after = function(_)
    require("yazi").setup({})
  end,
}
