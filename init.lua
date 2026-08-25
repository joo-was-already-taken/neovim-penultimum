vim.g.allow_downloads = true
vim.g.default_colorscheme = "evergarden"

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

require("opt")
require("keymaps")
require("git")
require("tab")
require("plugins")

vim.cmd.colorscheme(vim.g.default_colorscheme)
