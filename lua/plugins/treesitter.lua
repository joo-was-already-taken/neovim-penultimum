return {
  "nvim-treesitter",
  lazy = false,
  after = function(_)
    local ensure_installed = {
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
    require("nvim-treesitter.configs").setup({
      auto_install = vim.g.allow_downloads,
      ensure_installed = ensure_installed,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    })
  end,
}
