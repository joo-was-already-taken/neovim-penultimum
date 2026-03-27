return {
  {
    "mini.pairs",
    lazy = false,
    after = function(_)
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = true },
      })
    end,
  },
}
