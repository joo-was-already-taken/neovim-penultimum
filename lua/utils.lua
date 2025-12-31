local M = {}

function M.keymap_set(mode, new, prev)
  local opts = { noremap = true, silent = true }
  vim.keymap.set(mode, new, prev, opts)
end

function M.get_hl_property(hl, property)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hl)), property)
end

return M
