return {
  {
    "mini.pairs",
    event = "InsertEnter",
    after = function(_)
      require("mini.pairs").setup({})
    end,
  },
}
