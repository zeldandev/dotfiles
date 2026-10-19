-- ─────────────────────────────────────────────────────────────────────────────
-- SPLIT NAVIGATION
-- Quick shortcuts to split the current window. <leader>sv opens a vertical
-- split (two panes side by side) and <leader>sh opens a horizontal split
-- (two panes stacked). These map to the native <C-w>v / <C-w>s commands but
-- are faster to type with the leader prefix.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>sv", "<c-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<c-w>s", { desc = "Split window horizontally" })


-- ─────────────────────────────────────────────────────────────────────────────
-- MARKDOWN PREVIEW TOGGLE
-- Opens or closes the live markdown preview in the default browser.
-- The markdown-preview.nvim plugin must be installed for this to work.
-- Useful for editing README files or documentation while seeing the rendered
-- output in real time.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>mp', ":MarkdownPreviewToggle<cr>")

-- ─────────────────────────────────────────────────────────────────────────────
-- MOVE LINES
-- Move the current line (or selected block) up or down using Alt+j / Alt+k.
-- Works in Normal mode (single line), Insert mode (exits insert, moves,
-- re-enters insert), and Visual mode (moves the whole selection and re-selects
-- it so you can keep moving without re-selecting).
-- The "==" after the move re-indents the line to match its new context,
-- keeping indentation consistent after a move.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<a-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<a-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("i", "<a-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<a-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<a-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<a-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- ─────────────────────────────────────────────────────────────────────────────
-- BETTER INDENTING IN VISUAL MODE
-- By default, < and > in visual mode de/indent the selection and then drop
-- back to normal mode. Re-selecting with gv after each operation lets you
-- apply multiple indent levels without having to reselect the block each time.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- ─────────────────────────────────────────────────────────────────────────────
-- CENTERED SEARCH RESULTS
-- After jumping to the next (n) or previous (N) search result, the cursor is
-- re-centered on screen with "zz" and the fold at the cursor is opened with
-- "zv" (the "v" suffix). This prevents search from leaving the cursor near
-- the top or bottom edge of the viewport, which makes it hard to see context
-- above and below the match.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Goes to the next result on the search and put the cursor in the middle' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Goes to the prev result on the search and put the cursor in the middle' })

-- ─────────────────────────────────────────────────────────────────────────────
-- CLEAR SEARCH HIGHLIGHT
-- After a search the matched text stays highlighted until another search is
-- run. Pressing Escape in normal mode clears those highlights immediately so
-- they don't become visual noise once you are done looking at the results.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ─────────────────────────────────────────────────────────────────────────────
-- CHEAT SHEET FLOATING WINDOW
-- Opens a read-only floating window that renders ~/dotfiles/cheatsheet.md.
-- The window is sized to 80 % of the editor's columns and lines, centered on
-- screen, and uses a rounded border for a clean look. The buffer is set to
-- non-modifiable so the cheat sheet cannot be accidentally edited.
-- Both "q" and <Esc> are mapped locally inside the floating buffer to close it,
-- making it easy to dismiss without remembering a specific command.
-- ─────────────────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>?', function()
  -- Create a scratch buffer (not listed, not tied to a file on disk)
  local buf = vim.api.nvim_create_buf(false, true)

  -- Read the cheat sheet markdown file into the buffer
  local lines = vim.fn.readfile(vim.fn.expand("~/dotfiles/cheatsheet.md"))
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Lock the buffer so it cannot be modified accidentally
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  -- Enable markdown syntax highlighting inside the floating window
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })

  -- Calculate 80 % of the current editor dimensions for the floating window size
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Open the floating window centered relative to the whole editor ("editor" relative)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor', width = width, height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal', border = 'rounded'
  })

  -- Close the floating window with 'q' or <Esc> without affecting the global keymap
  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, noremap = true, silent = true })
  vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, noremap = true, silent = true })
end, { desc = "Mostrar Chuleta de Atajos" })
