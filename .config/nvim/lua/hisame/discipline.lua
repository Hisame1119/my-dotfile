local M = {}

function M.cowboy()
  ---@type table?
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    -- Neovim 0.11.4 で利用可能な libuv タイマーを使用
    local timer = assert(vim.uv.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      -- ★修正 1: '10j' のように回数指定がある場合
      -- count をリセットし、Cowboy ロジックをスキップして即座に 'j' を返す
      -- (Neovim が '10' と 'j' を組み合わせて実行してくれる)
      if vim.v.count > 0 then
        count = 0
        return map
      end

      -- 回数指定がない場合 (キーを連打している場合)
      if count >= 10 and vim.bo.buftype ~= "nofile" then
        -- しきい値 (10回) を超えたら通知を出す
        ok = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          id = "cowboy", -- ID を指定して通知が重複しないようにする
          keep = function()
            -- count が 10 以上である間、通知を維持する
            return count >= 10
          end,
        })
        if not ok then
          -- 通知に失敗した場合 (pcall が false を返した場合)
          -- フェイルセーフとして、キー操作を実行する
          return map
        end
        -- ★修正 2: 通知が成功した場合 (移動をキャンセルしたい場合)
        -- nil ではなく、空の文字列 "" を返す
        return ""
      else
        -- しきい値未満の場合
        count = count + 1
        -- タイマーを開始 (2000ms = 2秒)
        -- 2秒間キー入力がなければ、count を 0 にリセットする
        timer:start(2000, 0, function()
          count = 0
        end)
        -- キー操作を実行する
        return map
      end
    end, { expr = true, silent = true })
  end
end

return M
