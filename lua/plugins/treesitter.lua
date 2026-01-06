return {
  "nvim-treesitter",
  lazy = false,
  after = function(_)
    local parsers = {
      "nix",
      "lua",
      "bash",
      "gitignore",
      "python",
      "markdown",
      "markdown_inline",
      "query",
      "typst",
      "latex",
      "make",
      "regex",
      "toml",
      "yaml",
      "json",
      "vim",
      "vimdoc",
      "rust",
      "haskell",
      "go",
      "html",
      "c",
      "cpp",
      "cmake",
      "zig",
      "javascript",
      "css",
    }
    local ts = require("nvim-treesitter")
    vim.api.nvim_create_user_command("InstallTSParsers", function()
      local function contains(t, val)
        for _, v in ipairs(t) do
          if v == val then
            return true
          end
        end
        return false
      end

      local installed = ts.get_installed()
      local to_install = {}
      for _, parser in ipairs(parsers) do
        if not contains(installed, parser) then
          table.insert(to_install, parser)
        end
      end

      if #to_install > 0 then
        vim.notify(
          "Installing missing parsers: " .. table.concat(to_install, ", "),
          vim.log.levels.INFO
        )
        ts.install(to_install)
      else
        vim.notify("All declared parsers are already installed", vim.log.levels.INFO)
      end
    end, {})

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("nvim-treesitter-setup", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
