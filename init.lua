vim.g.allow_downloads = true
vim.g.default_colorscheme = "evergarden"

vim.deprecate = function() end

require("opt")
require("keymaps")
require("plugins")

vim.cmd.colorscheme(vim.g.default_colorscheme)
