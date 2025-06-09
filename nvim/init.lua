-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Figure insertion function for LaTeX workflow
function InsertFigure()
  local title = vim.fn.input("Figure title: ")
  if title ~= "" then
    local name = title:lower():gsub(" ", "-"):gsub("[^a-z0-9%-]", "")

    -- Create figure using inkscape-figures
    os.execute('ipe-fig create "' .. title .. '" ./figures/')

    -- Insert LaTeX code at current cursor position
    local latex_code = {
      "\\begin{figure}[ht]",
      "    \\centering",
      " \\includegraphics[width=0.8\\textwidth]{./figures/" .. name .. ".pdf}",
      "    \\caption{" .. title .. "}",
      "    \\label{fig:" .. name .. "}",
      "\\end{figure}",
    }

    vim.api.nvim_put(latex_code, "l", true, true)
  end
end

-- Keybindings for figure insertion
vim.keymap.set("n", "<leader>fi", InsertFigure, { desc = "Insert figure" })
vim.keymap.set("i", "<C-f>", function()
  InsertFigure()
  vim.cmd("startinsert")
end, { desc = "Insert figure (insert mode)" })
