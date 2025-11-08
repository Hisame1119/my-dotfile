return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    -- ★ 致命的エラーの修正: 'opts = function' が 'return opts' していなかった
    opts = function(_, opts)
      -- "No information available" メッセージをスキップする
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      -- ★ 修正: 'FocusLost'/'notify_send' のロジックを削除
      -- (これらは Linux デスクトップ通知用であり、Windows/PowerShell 環境では動作しないため)

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true

      -- ★ 致命的エラーの修正: 変更した 'opts' を返していなかった
      return opts
    end,
  },

  {
    "rcarriga/nvim-notify",
    -- ★ 致命的エラーの修正: 'opts = { ... }' から 'opts = function' に変更
    opts = function(_, opts)
      opts.timeout = 5000
      return opts
    end,
  },

  -- ★ 修正: 'snacks.nvim' の定義を1つに統合
  {
    "folke/snacks.nvim",
    -- ★ 致命的エラーの修正: 'opts = { ... }' から 'opts = function' に変更
    opts = function(_, opts)
      -- 1つ目の定義から
      opts.scroll = { enabled = false }

      -- 2つ目の定義から
      opts.dashboard = {
        preset = {
          header = [[
       ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
       ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
       ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
       ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
       ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
       ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
]],
        },
      }
      return opts
    end,
    keys = {}, -- 1つ目の定義にあった keys = {} もマージ
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    -- ★ 致命的エラーの修正: 'opts = { ... }' から 'opts = function' に変更
    opts = function(_, opts)
      -- 'opts.options' テーブルにあなたの設定を '深く' マージする
      vim.tbl_deep_extend("force", opts.options, {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      })
      return opts
    end,
  },

  -- filename (この設定は元から正しかったです)
  {
    "b0o/incline.nvim",
    dependencies = { "craftzdog/solarized-osaka.nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("solarized-osaka.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
            InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- statusline (この設定は元から正しかったです)
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
      return opts -- 元から 'return opts' がありませんでしたが、lualine.nvim は 'opts' を返す必要がないため OK です
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    -- ★ 致命的エラーの修正: 'opts = { ... }' から 'opts = function' に変更
    opts = function(_, opts)
      -- 'opts.plugins' テーブルにあなたの設定を '深く' マージする
      vim.tbl_deep_extend("force", opts.plugins, {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      })
      return opts
    end,
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  -- (この設定は元から正しかったです)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },
}
