return {
  "lualine",
  lazy = false,
  after = function(_)
    local codeium_status = {
      function()
        if vim.g.codeium_enabled then
          return "󰚩 roger roger"
        else
          return "󱚢 no clankers"
        end
      end,
      color = function()
        if vim.g.codeium_enabled then
          local function get_fg(hl_group)
            return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl_group)), "fg#")
          end
          return { fg = get_fg("Keyword") }
        else
          return nil
        end
      end,
    }

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
          -- {
          --   function()
          --     local reg = vim.fn.reg_recording()
          --     if reg ~= "" then
          --       return "recording @".. reg
          --     end
          --     return ""
          --   end,
          -- },
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
          codeium_status,
          "encoding",
          "fileformat",
          "filetype",
        },
      },
    })
  end,
}
 
