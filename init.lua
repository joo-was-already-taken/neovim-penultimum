vim.g.allow_downloads = true
vim.g.default_colorscheme = "evergarden"

require("opt")
require("keymaps")
require("plugins")

vim.cmd.colorscheme(vim.g.default_colorscheme)
