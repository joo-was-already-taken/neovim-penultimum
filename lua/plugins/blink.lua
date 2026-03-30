return {
  "blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  after = function(_)
    require("blink.cmp").setup({
      keymap = {
        ["<C-n>"] = { "select_next" },
        ["<C-p>"] = { "select_prev" },
        ["<C-y>"] = { "accept" },
      },
      sources = {
        default = { "lsp", "buffer", "snippets", "path" },
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    })
  end,
}
