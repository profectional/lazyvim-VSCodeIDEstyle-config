-- VSCode-like keymaps for LazyVim
-- Loaded on VeryLazy event
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- =============================
-- Clipboard & Selection
-- =============================

-- Visual delete without yanking (blackhole)
map("v", "d", '"_d', opts)
map("v", "x", '"_x', opts)

-- Cut selection to system clipboard (Ctrl+X)
map("v", "<C-x>", '"+d', opts)

-- Yank to system clipboard explicitly
map({ "v", "n" }, "Y", '"+y', opts)
map({ "v", "n" }, "yy", '"+yy', opts)

-- Paste from system clipboard (preserve clipboard)
map({ "n", "v" }, "p", '"_dP', opts)
map({ "n", "v" }, "P", '"_dP', opts)

-- Terminal-friendly paste (Shift+Insert)
map("i", "<S-Insert>", "<C-R>+", opts)
map("c", "<S-Insert>", "<C-R>+", opts)

-- CTRL-C to copy (works in insert + normal + visual)
map({ "i", "n", "v" }, "<C-c>", '"+y', opts)

-- Ctrl-V Normal mode paste
map("n", "<C-v>", '"+p', opts)

-- Ctrl-V Visual mode paste without overwriting clipboard
map("v", "<C-v>", '"_dP', opts)

-- Ctrl-V Insert mode paste
map("i", "<C-v>", "<C-R>+", opts)

-- CTRL-A to select all (insert + normal + visual)
map({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", opts)

-- CTRL-R to replace
vim.keymap.set("n", "<C-r>", [[:%s//gc<Left><Left><Left>]], {
  desc = "Search and replace",
})

-- =============================
-- File operations
-- =============================

-- CTRL-S to save
map({ "i", "n" }, "<C-s>", "<Esc>:w<CR>", opts)

-- =============================
-- Undo / Redo
-- =============================

-- CTRL-T to open new process
vim.keymap.set({ "i", "n" }, "<C-t>", ":!", { noremap = true })

-- CTRL-Z to undo
map({ "i", "n" }, "<C-z>", "<Esc>u", opts)

-- CTRL-Y to redo
map({ "i", "n" }, "<C-y>", "<Esc><C-r>", opts)

-- =========================================
-- VS CODE BRAIN MODE (LazyVim)
-- =========================================

-- Exit insert + select
vim.keymap.set("i", "<A-v>", "<Esc>v") -- character visual
vim.keymap.set("i", "<A-V>", "<Esc>V") -- line visual

-- QUICK WRAP (VS Code style)
vim.keymap.set("v", "(", 'c(<C-r>")<Esc>')
vim.keymap.set("v", "[", 'c[<C-r>"]<Esc>')
vim.keymap.set("v", "{", 'c{<C-r>"}<Esc>')

-- quotes
vim.keymap.set("v", '"', 'c"<C-r>""<Esc>')
vim.keymap.set("v", "'", "c'<C-r>\"<Esc>")

-- =============================
-- Search
-- =============================

-- CTRL-F → fuzzy search in current buffer
-- If visual selection exists, use it as default text
map({ "n", "v" }, "<C-f>", function()
  local builtin = require("telescope.builtin")
  local text = ""
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    vim.cmd('normal! "vy') -- yank visual selection to register v
    text = vim.fn.getreg("v")
  end
  if text ~= "" then
    text = text:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1") -- escape special chars
    builtin.current_buffer_fuzzy_find({ default_text = text })
  else
    builtin.current_buffer_fuzzy_find()
  end
end, opts)

-- =============================
-- Visual mode indentation
-- =============================

-- Visual mode tab: indent selection
map("v", "<Tab>", ">gv", opts)
-- Visual mode shift-tab: unindent selection
map("v", "<S-Tab>", "<gv", opts)

-- =============================
-- Buffer Navigation (like VSCode)
-- =============================

-- Jump to buffer by index in buffer list
for i = 1, 6 do
  vim.keymap.set("n", "<C-" .. i .. ">", function()
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    if #buffers >= i then
      vim.cmd("buffer " .. buffers[i].bufnr)
    end
  end, { noremap = true, silent = true })
end

