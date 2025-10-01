return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      direction = "float",
      open_mapping = nil, -- we will handle keymap manually
      close_on_exit = true,
      shade_terminals = true,
      shell = vim.o.shell,
      float_opts = {
        border = "rounded",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.6),
        winblend = 0,
      },
    })
  end,
}
