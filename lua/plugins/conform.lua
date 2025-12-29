return {
  "conform",
  event = "BufWritePre",
  cmd = "ConformInfo",
  after = function(_)
    require("conform").setup({
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = { "--style=file", "--fallback-style=LLVM" },
        },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        else
          return { timeout_ms = 500 }
        end
      end,
    })
  end,
}
