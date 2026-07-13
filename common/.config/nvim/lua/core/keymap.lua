-- Splits
vim.keymap.set("n", "<leader>sv", "<c-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<c-w>s", { desc = "Split window horizontally" })


-- markdown preview
vim.keymap.set('n', '<leader>mp', ":MarkdownPreviewToggle<cr>")

-- Move lines
vim.keymap.set("n", "<a-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<a-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<a-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<a-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<a-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<a-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- cursor in the middle of the screan for serach
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Goes to the next result on the search and put the cursor in the middle' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Goes to the prev result on the search and put the cursor in the middle' })

-- clear search highlight on pressing Esc in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Cheat sheet floating window
vim.keymap.set('n', '<leader>?', function()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.fn.readfile(vim.fn.expand("~/dotfiles/cheatsheet.md"))
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor', width = width, height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal', border = 'rounded'
  })
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, noremap = true, silent = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, noremap = true, silent = true })
end, { desc = "Mostrar Chuleta de Atajos" })
