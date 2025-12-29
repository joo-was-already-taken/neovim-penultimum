local format_opts = {
  lsp_fallback = false,
  async = true,
  timeout_ms = 5000,
}

return {
  "conform",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>fl",
      function()
        require("conform").format(format_opts)
      end,
      mode = { "n", "v" },
    },
    { "<leader>tf", "<cmd>ConformToggleFormatOnSave<CR>" },
  },
  after = function(_)
    local formatters_by_ft = {
      lua = { "stylua" },
      c = { "clang-format" },
      cpp = { "clang-format" },
    }
    local format_on_save_by_ft = {}
    for formatter, _ in pairs(formatters_by_ft) do
      format_on_save_by_ft[formatter] = false
    end

    require("conform").setup({
      formatters_by_ft = formatters_by_ft,
      formatters = {
        ["clang-format"] = {
          prepend_args = { "--style=file", "--fallback-style=LLVM" },
        },
      },
      format_on_save = function(bufnr)
        local should_format = format_on_save_by_ft[vim.bo[bufnr].filetype]
        if should_format then
          return { timeout_ms = 5000, lsp_fallback = false }
        else
          return
        end
      end,
    })

    vim.api.nvim_create_user_command("ConformToggleFormatOnSave", function()
      local ft = vim.bo.filetype
      format_on_save_by_ft[ft] = not format_on_save_by_ft[ft]
      if format_on_save_by_ft[ft] then
        vim.notify("Enabled format on save for " .. ft, vim.log.levels.INFO)
      else
        vim.notify("Disabled format on save for " .. ft, vim.log.levels.INFO)
      end
    end, {})
  end,
}
