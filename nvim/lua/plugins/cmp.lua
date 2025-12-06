return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- Make sure LSP is the FIRST source
      opts.sources = vim.list_extend({
        { name = "nvim_lsp", priority = 1000 },
      }, opts.sources or {})

      return opts
    end,
  },
}
