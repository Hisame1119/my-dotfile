-- -----------------------------------------------------------------
-- lua/core/options.lua
-- Neovim の基本設定 (init.vim の内容を統合)
-- -----------------------------------------------------------------

-- Leader キーを Space に設定 (キーマップより先に定義)
vim.g.mapleader = " "

local opt = vim.opt -- 可読性のためのローカル変数

-- -----------------------------------------------------------------
-- 基本設定
-- -----------------------------------------------------------------
opt.encoding = "utf-8"

opt.mouse = "a" -- マウスを有効にする
opt.clipboard = "unnamedplus" -- OSのクリップボードとヤンクを共有

opt.swapfile = false -- スワップファイルを作成しない
opt.backup = false -- バックアップファイルを作成しない
opt.undofile = true -- Undo 履歴をファイルに保存する
opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- undodir の場所 (Lua で安全に指定)

-- -----------------------------------------------------------------
-- UI 関連
-- -----------------------------------------------------------------
opt.termguicolors = true -- 24bitカラー (最重要)
opt.number = true -- 行番号を表示
opt.relativenumber = true -- 相対行番号を表示
opt.cursorline = true -- 現在の行をハイライト

opt.wrap = true -- 長い行を折り返す
opt.linebreak = true -- 折り返しを単語単位にする

opt.scrolloff = 8 -- スクロール時に上下に保つ行数
opt.sidescrolloff = 5 -- 水平スクロール時に左右に保つ列数

opt.showcmd = true -- コマンドを右下に表示
opt.signcolumn = "yes" -- 常に sign column を表示

-- -----------------------------------------------------------------
-- 検索関連
-- -----------------------------------------------------------------
opt.hlsearch = true -- 検索時にハイライト
opt.incsearch = true -- インクリメンタルサーチを有効に
opt.ignorecase = true -- 検索時に大文字小文字を無視
opt.smartcase = true -- 検索文字列に大文字が含まれていれば、大文字小文字を区別

-- -----------------------------------------------------------------
-- インデント・タブ設定
-- -----------------------------------------------------------------
opt.expandtab = true -- タブをスペースに展開
opt.tabstop = 2 -- タブの幅 (スペース 2 つ分)
opt.shiftwidth = 2 -- 自動インデントの幅
opt.softtabstop = 2 -- <Tab> キーを押したときの幅
opt.autoindent = true -- 自動インデント
opt.smartindent = true -- 新しい行で賢くインデント

-- -----------------------------------------------------------------
-- 背景透過設定 (init.vim から転記)
-- -----------------------------------------------------------------
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE" }) -- ウィンドウ分割線の背景も透過

-- -----------------------------------------------------------------
-- キーバインド (init.vim から転記)
-- -----------------------------------------------------------------
local keymap_opts = { noremap = true, silent = true }

-- Nvim-Tree (ファイルエクスプローラ)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { desc = "Find file in NvimTree" })

-- ウィンドウ操作
vim.keymap.set("n", "<C-h>", "<C-w>h", keymap_opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", keymap_opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", keymap_opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", keymap_opts)

-- 検索ハイライトを消す
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })
