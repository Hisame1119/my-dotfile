-- [[ グローバル変数 ]]
vim.g.mapleader = " "

-- [[ Neovim の必須設定 (0.11.4 に最適化) ]]
vim.opt.termguicolors = true -- 24-bit True Color を有効にする (古い t_Cs/t_Ce の代わり)
vim.opt.cmdheight = 0 -- コマンドラインを非表示にし、UIをクリーンにする (Neovim 0.8+ が前提)

-- [[ 一般的なエディタ設定 ]]
vim.opt.number = true -- 行番号を表示
vim.opt.title = true -- ウィンドウタイトルにファイル名を表示
vim.opt.showcmd = true -- 実行中のコマンドを右下に表示
vim.opt.laststatus = 3 -- 常にグローバルステータスラインを表示
vim.opt.scrolloff = 10 -- カーソル行が端から10行以内に入ったらスクロール
vim.opt.hlsearch = true -- 検索結果をハイライト
vim.opt.inccommand = "split" -- 検索/置換のプレビューをスプリットウィンドウで行う
vim.opt.mouse = "" -- マウス操作を無効にする

-- [[ インデントとタブ ]]
vim.opt.autoindent = true -- 自動インデント
vim.opt.smartindent = true -- 賢いインデント
vim.opt.expandtab = true -- タブをスペースに変換
vim.opt.shiftwidth = 2 -- インデントの幅
vim.opt.tabstop = 2 -- タブの幅
vim.opt.smarttab = true

-- [[ テキストの折り返しと表示 ]]
vim.opt.wrap = false -- 行を折り返さない
vim.opt.breakindent = true -- 折り返した行のインデントを合わせる

-- [[ 検索設定 ]]
vim.opt.ignorecase = true -- 検索時に大文字/小文字を無視する
vim.opt.smartcase = true -- ただし、検索語に大文字が含まれている場合は無視しない (自動で追加されます)

-- [[ バックアップとスワップファイル ]]
vim.opt.backup = false -- バックアップファイルを作成しない
vim.opt.swapfile = false -- スワップファイルを作成しない (LazyVim デフォルト)
vim.opt.writebackup = false -- 書き込み時のバックアップもしない (LazyVim デフォルト)
-- ★ 削除: backup = false のため、backupskip は不要

-- [[ システム・外部コマンド ]]
vim.opt.shell = "pwsh" -- ★ Windows の PowerShell をシェルとして明示的に指定 (重要)
vim.opt.shellcmdflag = "-c" -- 'pwsh -c "..."' の形式でコマンドを実行するため

-- [[ 動作設定 ]]
vim.opt.backspace = { "start", "eol", "indent" } -- Backspace でインデントや行頭も削除可能に
vim.opt.path:append({ "**" }) -- `find` コマンドなどでサブディレクトリを再帰的に検索
vim.opt.wildignore:append({ "*/node_modules/*" }) -- node_modules を検索から除外

-- [[ ウィンドウ管理 ]]
vim.opt.splitbelow = true -- 新しいウィンドウを下に開く
vim.opt.splitright = true -- 新しいウィンドウを右に開く
vim.opt.splitkeep = "cursor"

-- [[ フォーマット ]]
vim.opt.formatoptions:append({ "r" }) -- 'o' や 'O' で改行した際にコメントリーダーを引き継ぐ

-- [[ ファイルタイプ設定 (Lua で統一) ]]
vim.filetype.add({
  extension = {
    mdx = "mdx",
    astro = "astro", -- ★ autocmd から移動
  },
  filename = {
    Podfile = "ruby", -- ★ autocmd から移動
  },
})

-- [[ LazyVim 用のグローバル設定 ]]
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
