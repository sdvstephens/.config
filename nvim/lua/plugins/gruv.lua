return {
  "ellisonleao/gruvbox.nvim",
  lazy = false, -- Load Gruvbox at startup
  priority = 1000, -- Load Gruvbox before other plugins
  config = function()
    vim.o.background = "dark" -- Set dark mode
    vim.cmd("colorscheme gruvbox")
  end,
}
