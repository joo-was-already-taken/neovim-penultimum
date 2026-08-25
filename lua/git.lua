vim.api.nvim_create_user_command("GitExclude", function()
  vim.system(
    { "git", "rev-parse", "--git-path", "info/exclude" },
    { text = true },
    function(out)
      vim.schedule(function()
        if out.code == 0 then
          vim.cmd("edit " .. vim.fn.fnameescape(vim.trim(out.stdout)))
        else
          vim.notify("Not in a git repository", vim.log.levels.ERROR)
        end
      end)
    end
  )
end, { desc = "Open .git/info/exclude" })
