local keymap_set = require("utils").keymap_set

keymap_set("n", "<leader>q", "<cmd>q<CR>")
keymap_set("n", "<leader>Q", "<cmd>qa<CR>")

-- navigation
keymap_set({ "n", "v" }, "<C-d>", "<C-d>zz")
keymap_set({ "n", "v" }, "<C-u>", "<C-u>zz")
keymap_set({ "n", "v" }, "<C-f>", "<C-f>zz")
keymap_set({ "n", "v" }, "<C-b>", "<C-b>zz")

-- window and pane navigation
keymap_set("n", "<C-h>", "<C-w>h")
keymap_set("n", "<C-l>", "<C-w>l")
keymap_set("n", "<C-j>", "<C-w>j")
keymap_set("n", "<C-k>", "<C-w>k")
keymap_set("t", "<C-h>", "<cmd>wincmd h<CR>")
keymap_set("t", "<C-l>", "<cmd>wincmd l<CR>")
keymap_set("t", "<C-j>", "<cmd>wincmd j<CR>")
keymap_set("t", "<C-k>", "<cmd>wincmd k<CR>")

-- window management is configured with smart-splits.nvim)

-- indenting
keymap_set("v", "<", "<gv")
keymap_set("v", ">", ">gv")

-- editing
keymap_set("i", "<C-bs>", "<C-w>")
keymap_set("i", "<C-h>", "<C-w>")
keymap_set("n", "<leader>o", "o<ESC>")
keymap_set("n", "<leader>O", "O<ESC>")

keymap_set("v", "<leader>wc", function()
  local wc = vim.fn.wordcount().visual_words
  vim.notify("Word count: " .. tostring(wc), vim.log.levels.INFO)
end)

-- delete trailing whitespace
keymap_set("n", "<leader>wt", function()
  local cursor = vim.fn.getpos(".")
  pcall(function()
    vim.cmd([[%s/\s\+$//e]])
  end)
  vim.fn.setpos(".", cursor)
end)

keymap_set("n", "<leader>nh", "<cmd>nohlsearch<CR>")
