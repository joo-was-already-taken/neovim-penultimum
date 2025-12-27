local M = {}

function M.keymap_set(mode, new, prev)
  local opts = { noremap = true, silent = true }
  vim.keymap.set(mode, new, prev, opts)
end

return M
