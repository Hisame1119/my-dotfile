-- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua

local M = {}

local hexChars = "0123456789abcdef"

function M.hex_to_rgb(hex)
  hex = string.lower(hex)
  local ret = {}
  for i = 0, 2 do
    -- 16進数の 'FF' などを取り出す (例: #RRGGBB の RR)
    local char1 = string.sub(hex, i * 2 + 2, i * 2 + 2)
    local char2 = string.sub(hex, i * 2 + 3, i * 2 + 3)
    -- 10進数 (0-15) に変換
    local digit1 = string.find(hexChars, char1) - 1
    local digit2 = string.find(hexChars, char2) - 1
    -- 0.0-1.0 の範囲に正規化して保存
    ret[i + 1] = (digit1 * 16 + digit2) / 255.0
  end
  return ret
end

--[[
 * RGB (0.0-1.0) から HSL (0-360, 0-100, 0-100) へ変換
 * Assumes r, g, and b are contained in the set [0, 1] and
 * returns h, s, and l in the set [0-360, 0-100, 0-100].
]]
function M.rgbToHsl(r, g, b)
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h = 0
  local s = 0
  local l = 0

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic (無彩色)
  else
    local d = max - min
    if l > 0.5 then
      s = d / (2 - max - min)
    else
      s = d / (max + min)
    end
    if max == r then
      h = (g - b) / d
      if g < b then
        h = h + 6
      end
    elseif max == g then
      h = (b - r) / d + 2
    elseif max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h * 360, s * 100, l * 100
end

--[[
 * HSL (0.0-1.0) から RGB (0-255) へ変換
 * Assumes h, s, and l are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
]]
function M.hslToRgb(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    -- ★修正: 'function' -> 'local function' に変更
    -- グローバルスコープを汚染しないようにする
    local function hue2rgb(p, q, t)
      if t < 0 then
        t = t + 1
      end
      if t > 1 then
        t = t - 1
      end
      if t < 1 / 6 then
        return p + (q - p) * 6 * t
      end
      if t < 1 / 2 then
        return q
      end
      if t < 2 / 3 then
        return p + (q - p) * (2 / 3 - t) * 6
      end
      return p
    end

    local q
    if l < 0.5 then
      q = l * (1 + s)
    else
      q = l + s - l * s
    end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  end

  return r * 255, g * 255, b * 255
end

function M.hexToHSL(hex)
  -- ★修正: 'solarized-osaka.hsluv' は使われていないため削除
  -- local hsluv = require("solarized-osaka.hsluv")
  local rgb = M.hex_to_rgb(hex)
  local h, s, l = M.rgbToHsl(rgb[1], rgb[2], rgb[3])

  return string.format("hsl(%d, %d, %d)", math.floor(h + 0.5), math.floor(s + 0.5), math.floor(l + 0.5))
end

--[[
 * HSL (0-360, 0-100, 0-100) から HEX (#RRGGBB) へ変換
]]
function M.hslToHex(h, s, l)
  -- HSL を 0.0-1.0 の範囲に正規化して hslToRgb に渡す
  local r, g, b = M.hslToRgb(h / 360, s / 100, l / 100)

  return string.format("#%02x%02x%02x", r, g, b)
end

function M.replaceHexWithHSL()
  -- 現在の行番号を取得
  local line_number = vim.api.nvim_win_get_cursor(0)[1]

  -- 現在の行の内容を取得
  local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

  -- ★修正: gmatch パターンを '#%x{6}' に変更
  -- これで '#RRGGBB' (6桁の16進数) にのみマッチし、
  -- '#123' (3桁) や '#aabbccdd' (8桁) を無視するため、エラーを防げる
  for hex in line_content:gmatch("#%x{6}") do
    local hsl = M.hexToHSL(hex)
    line_content = line_content:gsub(hex, hsl)
  end

  -- 行の内容をバッファに書き戻す
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
end

return M
