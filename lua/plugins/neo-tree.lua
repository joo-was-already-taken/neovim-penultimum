return {
  "neo-tree.nvim",
  lazy = false,
  after = function(_)
    require("neo-tree").setup({
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      default_component_configs = {
        last_modified = { format = "%Y-%m-%d %H:%M" },
        created = { format = "%Y-%m-%d %H:%M" },
      },

      filesystem = {
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },

      buffers = {
        show_unloaded = true,
      },

      window = { position = "current" },
    })

    local keymap_set = require("utils").keymap_set
    keymap_set("n", "<leader>e", "<cmd>Neotree filesystem toggle reveal float<CR>")
    keymap_set("n", "<leader>g", "<cmd>Neotree git_status toggle reveal float<CR>")
    keymap_set("n", "<leader>b", "<cmd>Neotree buffers toggle reveal float<CR>")
  end,
}
