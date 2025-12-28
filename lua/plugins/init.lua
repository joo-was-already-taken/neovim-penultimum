if vim.g.allow_downloads then
  require("paq")({
    "savq/paq-nvim",
    "lumen-oss/lz.n",

    { "nvim-lua/plenary.nvim", as = "plenary" },
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    { "nvimtools/hydra.nvim", as = "hydra" },
    { "nvim-treesitter/nvim-treesitter", branch = "master", opt = true },
    { "nvim-neo-tree/neo-tree.nvim", as = "neo-tree", opt = true },

    { "alexghergh/nvim-tmux-navigation", opt = true },
    { "nvim-telescope/telescope.nvim", as = "telescope", opt = true },
    { "tpope/vim-obsession", opt = true },
    { "mrjones2014/smart-splits.nvim", as = "smart-splits-nvim", opt = true },
    { "Saghen/blink.cmp", opt = true },
    { "nvim-mini/mini.pairs", opt = true },
    { "neovim/nvim-lspconfig", opt = true },
    { "glepnir/lspsaga.nvim", as = "lspsaga", opt = true },
    { "mbbill/undotree", opt = true },
    { "stevearc/conform.nvim", as = "conform", opt = true },

    { "everviolet/nvim", as = "evergarden", opt = true },
  })
end

require("lz.n").load({
  require("plugins/treesitter"),
  require("plugins/neo-tree"),
  require("plugins/telescope"),
  require("plugins/smart-splits"),
  { "vim-obsession", cmd = "Obsession" },
  {
    "nvim-tmux-navigation",
    after = function(plugin)
      require(plugin.name).setup({
        disable_when_zoomed = true,
      })
    end,
    keys = {
      { "<C-h>", function() require("nvim-tmux-navigation").NvimTmuxNavigateLeft() end },
      { "<C-l>", function() require("nvim-tmux-navigation").NvimTmuxNavigateRight() end },
      { "<C-j>", function() require("nvim-tmux-navigation").NvimTmuxNavigateDown() end },
      { "<C-k>", function() require("nvim-tmux-navigation").NvimTmuxNavigateUp() end },
    },
  },
})
