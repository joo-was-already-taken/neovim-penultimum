return {
  "lualine.nvim",
  lazy = false,
  after = function(_)
    require("lualine").setup({
      options = {
        globalstatus = true,
        component_separators = "│",
        section_separators = "",
      },
      sections = {
        lualine_b = {
          "branch",
          "diff",
        },
        lualine_c = {
          "filename",
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg ~= "" then
                return "recording @" .. reg
              end
              return ""
            end,
          },
          {
            "diagnostics",
            symbols = {
              error = "E",
              warn = "W",
              info = "I",
              hint = "H",
            },
          },
        },
        lualine_x = {
          {
            "copilot",
            show_colors = true,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    })
  end,
}
