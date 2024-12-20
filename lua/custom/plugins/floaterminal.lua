-- how to create a floating window in neovim, I want it to optionally take the width and height in a table, I want it to default to 80% of the width and 80% of the height of the current screen and I want it to be centered
-- could you write the function for me?

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_terminal(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- calculate position for centering the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- local buf = vim.api.nvim_create_buf(false, true)

  -- window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  return { buf = buf, win = win }
end

-- state.floating = create_floating_terminal()
-- print(vim.inspect(state.floating))

local toggle_floating_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_terminal { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Usage:
vim.api.nvim_create_user_command('Fterm', toggle_floating_terminal, {})
vim.keymap.set({ 'n', 't' }, '<space>tt', toggle_floating_terminal)
