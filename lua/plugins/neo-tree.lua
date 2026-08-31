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

      window = {
        position = "current",
        mappings = {
          ["<cr>"] = "open_safe",
        },
      },
      commands = {
        open_safe = function(state)
          local node = state.tree:get_node()
          if node and node.type == "file" and state.current_position == "float" then
            local path = node.path or node:get_id()
            require("neo-tree.ui.renderer").close(state)
            vim.cmd.edit(vim.fn.fnameescape(path))
          else
            local cmds = require("neo-tree.sources." .. state.name .. ".commands")
            if cmds and cmds.open then
              cmds.open(state)
            else
              require("neo-tree.sources.common.commands").open(state)
            end
          end
        end,
      },
    })

    local keymap_set = require("utils").keymap_set
    keymap_set("n", "<leader>e", "<cmd>Neotree filesystem toggle reveal float<CR>")
    keymap_set("n", "<leader>ge", "<cmd>Neotree git_status toggle reveal float<CR>")
    keymap_set("n", "<leader>b", "<cmd>Neotree buffers toggle reveal float<CR>")
  end,
}
