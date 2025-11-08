local discipline = require("hisame.discipline")

discipline.cowboy()

local keymap = vim.keymap
-- noremap = true: マッピングを再帰的に解決しない (推奨)
-- silent = true: コマンドラインにマッピングを表示しない
local opts = { noremap = true, silent = true }

--
-- レジスタ関連のマッピング
-- ※これらはコマンドシーケンス（"_" や "x" を順に実行）であるため、
--   `noremap = false` (デフォルト) が意図した動作です。`opts` は適用しません。
--

-- レジスタに影響を与えずに操作する
keymap.set("n", "x", '"_x') -- x で削除した文字をレジスタに入れない
keymap.set("n", "<Leader>c", '"_c') -- c で変更した内容をレジスタに入れない
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d') -- d で削除した内容をレジスタに入れない
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- '0' (ヤンク) レジスタからペースト
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')

--
-- 編集・移動系マッピング (noremap = true を適用)
--

-- 数字のインクリメント/デクリメント
keymap.set("n", "+", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- [注意] dw (delete word) という基本モーションを上書きしています
-- コメント通り「単語を後ろに削除」するマッピング
keymap.set("n", "dw", 'vb"_d', { silent = true }) -- noremap = false (default)

-- すべて選択
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Save with root permission (Windows では動作しないためコメントアウトのまま)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- 継続行の自動インデントを無効にして改行
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- 削除: <C-m> (Enter) が <C-i> (ジャンプ) になるマッピング。
-- ノーマルモードでEnterキーが効かなくなるため削除。
-- keymap.set("n", "<C-m>", "<C-i>", opts)

--
-- ウィンドウ・タブ操作 (noremap = true を適用)
--

-- 新しいタブ
keymap.set("n", "te", ":tabedit<Return>", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- ウィンドウ分割
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- ウィンドウ移動
keymap.set("n", "sh", "<C-w>h", opts)
keymap.set("n", "sk", "<C-w>k", opts)
keymap.set("n", "sj", "<C-w>j", opts)
keymap.set("n", "sl", "<C-w>l", opts)

-- ウィンドウリサイズ
keymap.set("n", "<C-w><left>", "<C-w><", opts)
keymap.set("n", "<C-w><right>", "<C-w>>", opts)
keymap.set("n", "<C-w><up>", "<C-w>+", opts)
keymap.set("n", "<C-w><down>", "<C-w>-", opts)

--
-- プラグイン・カスタム関数
--

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

keymap.set("n", "<leader>r", function()
  require("hisame.hsl").replaceHexWithHSL()
end, opts) -- opts を追加

keymap.set("n", "<leader>i", function()
  require("hisame.lsp").toggleInlayHints()
end, opts) -- opts を追加

vim.api.nvim_create_user_command("ToggleAutoformat", function()
  require("hisame.lsp").toggleAutoformat()
end, {})
