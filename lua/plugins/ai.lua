return {
  "copilot.lua",
  cmd = "Copilot",
  keys = {
    { "<leader>ai", "<cmd>Copilot toggle<CR>" },
  },
  after = function(_)
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    })
  end,
}
