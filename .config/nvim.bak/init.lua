-- -----------------------------------------------------------------
-- init.lua
-- Neovim のエントリーポイント
-- -----------------------------------------------------------------
-- -----------------------------------------------------------------
-- lazy.nvim (プラグインマネージャー) のセットアップ
-- -----------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------
-- マッピングが正しく行われるように、lazy.nvim をロードする前に
-- `mapleader` と `maplocalleader` を設定。
-- ここで他の設定 (vim.opt) も設定する。
-- -----------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- core/options.lua を読み込む
require("core.options")

-- lazy.nvim をセットアップし、lua/plugins/ 以下の .lua ファイルをすべて読み込む
require("lazy").setup({
  spec = {
    {{ import = "plugins"}}
  },
  -- プラグインのインストール時に使用されるカラースキーム。
  install = { colorscheme = { "habamax" } },
  -- プラグインの更新を自動的にチェックする
  checker = { enabled = true },
})


