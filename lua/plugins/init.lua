if vim.g.allow_downloads then
  require("paq")({
    "savq/paq-nvim",
    "lumen-oss/lz.n",

    { "nvim-lua/plenary.nvim", as = "plenary" },
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    { "nvimtools/hydra.nvim", as = "hydra" },
    { "rcarriga/nvim-notify", as = "notify" },

    { "nvim-treesitter/nvim-treesitter", branch = "master", opt = true },
    { "nvim-neo-tree/neo-tree.nvim", as = "neo-tree", opt = true },
    { "nvim-lualine/lualine.nvim", as = "lualine", opt = true },
    { "folke/noice.nvim", as = "noice", opt = true },

    { "alexghergh/nvim-tmux-navigation", opt = true },
    { "nvim-telescope/telescope.nvim", as = "telescope", opt = true },
    { "tpope/vim-obsession", opt = true },
    { "mrjones2014/smart-splits.nvim", as = "smart-splits-nvim", opt = true },
    { "Saghen/blink.cmp", opt = true },
    { "nvim-mini/mini.pairs", opt = true },
    { "neovim/nvim-lspconfig", opt = true },
    { "glepnir/lspsaga.nvim", as = "lspsaga", opt = true },
    { "mbbill/undotree", opt = true },
    { "kylechui/nvim-surround", opt = true },

    { "everviolet/nvim", as = "evergarden", opt = true },
  })
end

local lz_specs = {
  require("plugins/treesitter"),
  require("plugins/neo-tree"),
  require("plugins/telescope"),
  require("plugins/lualine"),
  require("plugins/smart-splits"),
  require("plugins/blink"),
  { "vim-obsession", cmd = "Obsession" },
  {
    "nvim-tmux-navigation",
    after = function(_)
      require("nvim-tmux-navigation").setup({
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
  {
    "undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>" },
    },
    after = function(_)
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SplitWidth = 50
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "nvim-surround",
    lazy = false,
    after = function(_) require("nvim-surround").setup({}) end,
  },
}

local function extend(a, b)
  for _, x in ipairs(b) do
    table.insert(a, x)
  end
end

extend(lz_specs, require("plugins/looks"))
extend(lz_specs, require("plugins/mini"))
extend(lz_specs, require("plugins/lsp"))
extend(lz_specs, require("plugins/colorschemes"))

require("lz.n").load(lz_specs)
