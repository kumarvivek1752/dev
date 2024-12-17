vim.cmd("set scrolloff=8")
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set tabstop=4 softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set smartindent")
vim.cmd("set guicursor=")
vim.cmd("set clipboard=unnamed")
vim.cmd("set splitright")
-- Leader key
vim.g.mapleader = " "

-- default keymaps
vim.keymap.set("n", "<leader>k", ":lua vim.lsp.buf.format()<CR> :wq<CR>")
vim.keymap.set("n", "<leader>gf", ":lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "<leader>fk", ":q!<CR>")
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
-- vim.keymap.set("n", "<leader>w", ":lua vim.lsp.buf.format()<CR> :w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
--yank to keyboard in visual mode

-- Coc keymaps
-- vim.cmd("inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : '<Tab>'")

-- Window navigatio
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>h")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- insert mode key binding.
vim.cmd("inoremap <C-o> <C-o>o")

-- Exit by 'Esc' in terminal mode
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- FZF keybinds
vim.keymap.set("n", "<leader>pv", ":FZF<CR>")

--netrw explorer

vim.cmd("nnoremap <leader>ex :Explore<CR>")
--make file exucutatble
vim.cmd("nnoremap <leader>x :!chmod +x %<CR>")

-- open recent file
vim.cmd('nnoremap <leader>or :e #<1<CR>')


--
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")


-- paste and move
vim.cmd('vnoremap <leader>p "_dp ')
vim.cmd('nnoremap <leader>y "+y ')
vim.cmd('vnoremap <C-c> "+y')
vim.cmd('nnoremap <leader>Y gg"+yG ')
vim.cmd("vnoremap J :m '>+1<CR>gv=gv")
vim.cmd("vnoremap K :m '<-2<CR>gv=gv")
vim.cmd("nnoremap <C-j> :cnext<CR>")
vim.cmd("nnoremap <C-k> :cprev<CR>")


-- markdown previw
vim.cmd('nnoremap <leader>m :PeekOpen<CR>')
vim.cmd('nnoremap <leader>s :PeekClose<CR>')
