return {
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_view_method = "skim"

      vim.g.vimtex_complete_enabled = 0
      vim.g.vimtex_complete_close_braces = 0

      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "./.latexmk/aux",
        out_dir = "./.latexmk/out",
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = {
          "-pdf",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }

      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "Package hyperref Warning",
        "Package fancyhdr Warning",
        "headheight is too small",
        "There were undefined references",
        "Label(s) may have changed",
        "Package biblatex Warning",
        "Please (re)run Biber",
      }
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.texlab.setup({
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = true,
            },
            completion = {
              matcher = "fuzzy",
            },
            experimental = {
              followPackageLinks = true,
            },
          },
        },
        root_dir = function(fname)
          return lspconfig.util.root_pattern(".latexmkrc", ".git")(fname) or vim.fn.getcwd()
        end,
      })
    end,
  },
}
