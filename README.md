# VSCode-like keymaps for LazyVim

Loaded on `VeryLazy` event.

This file contains custom keybindings that make LazyVim behave more like VSCode while preserving Vim modal editing.

---

## Lua Keymap Configuration

```lua
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

-- CTRL-C to copy
map({ "i", "n", "v" }, "<C-c>", '"+y', opts)

-- Ctrl-V Normal mode paste
map("n", "<C-v>", '"+p', opts)

-- Ctrl-V Visual mode paste without overwriting clipboard
map("v", "<C-v>", '"_dP', opts)

-- Ctrl-V Insert mode paste
map("i", "<C-v>", "<C-R>+", opts)

-- CTRL-A select all
map({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", opts)

-- CTRL-R search/replace
vim.keymap.set("n", "<C-r>", [[:%s//gc<Left><Left><Left>]], {
  desc = "Search and replace",
})

-- =============================
-- File operations
-- =============================

-- CTRL-S save
map({ "i", "n" }, "<C-s>", "<Esc>:w<CR>", opts)

-- =============================
-- Undo / Redo
-- =============================

-- CTRL-T open shell command
vim.keymap.set({ "i", "n" }, "<C-t>", ":!", { noremap = true })

-- CTRL-Z undo
map({ "i", "n" }, "<C-z>", "<Esc>u", opts)

-- CTRL-Y redo
map({ "i", "n" }, "<C-y>", "<Esc><C-r>", opts)

-- =========================================
-- VS CODE BRAIN MODE (LazyVim)
-- =========================================

-- Exit insert + select
vim.keymap.set("i", "<A-v>", "<Esc>v")
vim.keymap.set("i", "<A-V>", "<Esc>V")

-- QUICK WRAP (VS Code style)
vim.keymap.set("v", "(", 'c(<C-r>")<Esc>')
vim.keymap.set("v", "[", 'c[<C-r>"]<Esc>')
vim.keymap.set("v", "{", 'c{<C-r>"}<Esc>')

-- quotes
vim.keymap.set("v", '"', 'c"<C-r>""<Esc>')
vim.keymap.set("v", "'", "c'\"<C-r>\"<Esc>")

-- =============================
-- Search
-- =============================

map({ "n", "v" }, "<C-f>", function()
  local builtin = require("telescope.builtin")
  local text = ""

  if vim.fn.mode() == "v" or vim.fn.mode() == "V" then
    vim.cmd('normal! "vy')
    text = vim.fn.getreg("v")
  end

  if text ~= "" then
    text = text:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
    builtin.current_buffer_fuzzy_find({ default_text = text })
  else
    builtin.current_buffer_fuzzy_find()
  end
end, opts)

-- =============================
-- Visual indentation
-- =============================

map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)

-- =============================
-- Buffer Navigation (VSCode style)
-- =============================

for i = 1, 6 do
  vim.keymap.set("n", "<C-" .. i .. ">", function()
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    if #buffers >= i then
      vim.cmd("buffer " .. buffers[i].bufnr)
    end
  end, { noremap = true, silent = true })
end
```

---

## Notes

- Uses system clipboard (`+ register`)
- Overrides some default Vim bindings for VSCode-like behavior
- Loaded in LazyVim on `VeryLazy`
- Keeps modal editing intact while adding IDE-like shortcuts

---

