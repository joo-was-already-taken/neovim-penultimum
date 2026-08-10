return {
  "copilot.lua",
  cmd = "Copilot",
  keys = {
    {
      "<leader>ai",
      function()
        require("copilot.suggestion").toggle_auto_trigger()
      end,
    },
  },
  after = function(_)
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = false,
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
