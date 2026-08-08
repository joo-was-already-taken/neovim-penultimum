local augroup = vim.api.nvim_create_augroup("TabSettings", { clear = true })

local function apply_to_every_buf_by_filetype(filetype, callback)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == filetype then
      vim.api.nvim_buf_call(buf, callback)
    end
  end
end

vim.api.nvim_create_user_command("TabWidth", function(opts)
  local width = tonumber(opts.args)
  if not width then
    vim.notify("Invalid width", vim.log.levels.ERROR)
    return
  end
  local filetype = vim.bo.filetype

  local apply_to_buffer = function()
    vim.bo.tabstop = width
    vim.bo.shiftwidth = width
    vim.bo.softtabstop = width
  end

  if filetype ~= "" then
    apply_to_every_buf_by_filetype(filetype, apply_to_buffer)

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = filetype,
      callback = apply_to_buffer,
      desc = "Set tab width for " .. filetype,
    })
  else
    apply_to_buffer()
  end
end, { nargs = 1, desc = "Set tab width for current filetype" })

vim.api.nvim_create_user_command("TabExpand", function(opts)
  local true_args = { "true", "on", "yes", "1" };
  local false_args = { "false", "off", "no", "0" };

  local function is_in_array(elem, arr)
    for _, e in ipairs(arr) do
      if elem == e then
        return true
      end
    end
    return false
  end
  local is_true_arg = is_in_array(opts.args, true_args)
  local is_false_arg = is_in_array(opts.args, false_args)
  if not is_true_arg and not is_false_arg then
    vim.notify("Invalid argument: '" .. opts.args .. "'", vim.log.levels.ERROR)
  end

  local expand = is_true_arg

  local filetype = vim.bo.filetype

  local apply_to_buffer = function()
    vim.bo.expandtab = expand
  end

  if filetype ~= "" then
    apply_to_every_buf_by_filetype(filetype, apply_to_buffer)

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = filetype,
      callback = apply_to_buffer,
      desc = "Set expandtab for " .. filetype,
    })
  else
    apply_to_buffer()
  end
end, { nargs = 1, desc = "Set whether tab inserts spaces for current filetype" })

vim.api.nvim_create_user_command("TabReset", function()
  local filetype = vim.bo.filetype
  if filetype == "" then
    vim.notify("No filetype to reset for current buffer")
    return
  end

  vim.api.nvim_clear_autocmds({ group = augroup, pattern = filetype })

  apply_to_every_buf_by_filetype(filetype, function()
    vim.cmd.setlocal("tabstop< shiftwidth< softtabstop< expandtab<")
    vim.cmd.filetype("detect")
  end)

  vim.notify("Reset tab settings for all " .. filetype .. " buffers")
end, { desc = "Reset custom tab settings for current filetype" })
