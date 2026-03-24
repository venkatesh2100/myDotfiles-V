return {
  -- Autopairs (adds automatic {}, [], (), "")
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- enable Treesitter integration
      })
    end,
  },

  -- Treesitter (better syntax + indentation)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = true },
      indent = { enable = true }, -- smart indentation
    },
  },

  -- Formatter (auto format on save, like VS Code)
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Some sensible defaults
  {
    "LazyVim/LazyVim",
    opts = {
      -- extra editor settings
      defaults = {
        -- indentation
        opt = {
          autoindent = true,
          smartindent = true,
          cindent = true,
        },
      },
    },
  },
}
