-- Term Toggle Function
local term_buf = nil
local term_win = nil

function TermToggle(width)
  -- make the terminal window
  if term_win == nil or not vim.api.nvim_win_is_valid(term_win) then
    -- open vertical split
    vim.cmd("botright vnew")
    if width ~= nil then vim.cmd("resize " .. width) end
    term_win = vim.api.nvim_get_current_win()
    --local new_buf = vim.api.nvim_get_current_buf()

    if term_buf == nil or not vim.api.nvim_buf_is_valid(term_buf) then
      -- create terminal buffer
      vim.cmd("terminal")
      term_buf = vim.api.nvim_get_current_buf()
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.signcolumn = "no"
    end

    --vim.cmd("bd " .. new_buf)      -- cleanup new buffer
    vim.cmd("buffer " .. term_buf) -- go to terminal buffer
  end

  vim.api.nvim_set_current_win(term_win)
  vim.cmd("startinsert!")
end

-- Term Toggle Keymaps
vim.keymap.set("n", "<leader>tt", ":lua TermToggle(nil)<CR>", { noremap = true, silent = true })

--vim.cmd('autocmd TermOpen * setlocal nonumber norelativenumber')
--vim.cmd('autocmd TermOpen * startinsert')
vim.env.EDITOR = 'nvr --servername "$NVIM" -cc split --remote-wait'
vim.env.GIT_EDITOR = 'nvr --servername "$NVIM" -cc split --remote-wait'
vim.cmd('autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete')
