return {
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require("luasnip-latex-snippets").setup()
      require("luasnip").config.setup({ enable_autosnippets = true })
      local ls = require("luasnip")
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        once = true,
        callback = function()
          local utils = require("luasnip-latex-snippets.util.utils")
          local pipe = utils.pipe
          local is_math = utils.with_opts(utils.is_math, false)
          local no_backslash = utils.no_backslash
          -- ============================================
          -- MATH MODE SNIPPETS
          -- ============================================
          local parse_snippet_math = ls.extend_decorator.apply(ls.parser.parse_snippet, {
            condition = pipe({ is_math, no_backslash }),
          }) --[[@as function]]


-- Some things for transfering to yasnippets
          -- condition: (and (texmathp) 'auto)
          -- condition: (and (texmathp) (quote auto))
          --







          local math_snippets = {
            -- ALGEBRA OPERATORS
            parse_snippet_math({ trig = "Ker", name = "Kernel" }, "\\Ker "),
            parse_snippet_math({ trig = "Coker", name = "Cokernel (capital)" }, "\\Coker "),
            parse_snippet_math({ trig = "coker", name = "cokernel (lowercase)" }, "\\coker "),
            parse_snippet_math({ trig = "Img", name = "Image (capital)" }, "\\Img "),

            -- Homological Algebra
            parse_snippet_math({ trig = "Hom", name = "Hom functor" }, "\\Hom($1, $2)$0"),
            parse_snippet_math({ trig = "Mor", name = "Mor" }, "\\Mor($1, $2)$0"),
            parse_snippet_math({ trig = "End", name = "End" }, "\\End($1)$0"),
            parse_snippet_math({ trig = "Aut", name = "Aut" }, "\\Aut($1)$0"),
            parse_snippet_math({ trig = "Inn", name = "Inn" }, "\\Inn($1)$0"),
            parse_snippet_math({ trig = "Ext", name = "Ext functor" }, "\\Ext^{$1}($2, $3)$0"),
            parse_snippet_math({ trig = "Tor", name = "Tor functor" }, "\\Tor_{$1}($2, $3)$0"),
            parse_snippet_math({ trig = "Hol", name = "Hol" }, "\\Hol "),
            parse_snippet_math({ trig = "Fit", name = "Fitt" }, "\\Fit "),
            parse_snippet_math({ trig = "Der", name = "Der" }, "\\Der "),
            parse_snippet_math({ trig = "PDer", name = "PDer" }, "\\PDer "),

            -- Group Theory
            parse_snippet_math({ trig = "Gal", name = "Galois group" }, "\\Gal($1)$0"),
            parse_snippet_math({ trig = "Syl", name = "Sylow" }, "\\Syl_{$1}($2)$0"),

            -- Spectrum and Rank
            parse_snippet_math({ trig = "Spec", name = "Spectrum" }, "\\Spec($1)$0"),
            parse_snippet_math({ trig = "rank", name = "rank" }, "\\rank($1)$0"),

            -- LIE ALGEBRAS & FRAKTUR
            parse_snippet_math({ trig = "fkg", name = "fraktur g" }, "\\kg "),
            parse_snippet_math({ trig = "fkh", name = "fraktur h" }, "\\kh "),
            parse_snippet_math({ trig = "fkn", name = "fraktur n" }, "\\kn "),
            parse_snippet_math({ trig = "fkb", name = "fraktur b (Borel)" }, "\\kb "),
            parse_snippet_math({ trig = "fku", name = "fraktur u" }, "\\ku "),
            parse_snippet_math({ trig = "fkz", name = "fraktur z" }, "\\kz "),

            -- Ideals
            parse_snippet_math({ trig = "fkp", name = "prime ideal p" }, "\\kp "),
            parse_snippet_math({ trig = "fkq", name = "prime ideal q" }, "\\kq "),
            parse_snippet_math({ trig = "fkm", name = "maximal ideal m" }, "\\km "),

            -- Lie algebra groups
            parse_snippet_math({ trig = "fgl", name = "frak gl" }, "\\gl "),
            parse_snippet_math({ trig = "fsl", name = "frak sl" }, "\\sl "),

            -- CALLIGRAPHIC & SCRIPT
            parse_snippet_math({ trig = "mcF", name = "mathcal F" }, "\\mcF "),
            parse_snippet_math({ trig = "mcG", name = "mathcal G" }, "\\mcG "),
            parse_snippet_math({ trig = "mcH", name = "mathcal H" }, "\\mcH "),
            parse_snippet_math({ trig = "mcO", name = "mathcal O" }, "\\mcO "),
            parse_snippet_math({ trig = "mcA", name = "mathcal A" }, "\\mcA "),
            parse_snippet_math({ trig = "mcB", name = "mathcal B" }, "\\mcB "),
            parse_snippet_math({ trig = "mcC", name = "mathcal C" }, "\\mcC "),
            parse_snippet_math({ trig = "mcL", name = "mathcal L" }, "\\mcL "),

            parse_snippet_math({ trig = "sA", name = "script A" }, "\\sA "),
            parse_snippet_math({ trig = "sF", name = "script F" }, "\\sF "),
            parse_snippet_math({ trig = "sG", name = "script G" }, "\\sG "),

            -- ARROWS & MAPS
            parse_snippet_math({ trig = "inj", name = "injection" }, "\\injto "),
            parse_snippet_math({ trig = "surj", name = "surjection" }, "\\surjto "),
            parse_snippet_math({ trig = "xto", name = "xrightarrow" }, "\\taking{$1} "),
            parse_snippet_math({ trig = "iinv", name = "inverse" }, "\\inv "),

            -- DERIVATIVES
            parse_snippet_math({ trig = "pdd", name = "partial derivative display" }, "\\pdd{$1}{$2}$0"),
            parse_snippet_math({ trig = "pd", name = "partial derivative inline" }, "\\pd{$1}{$2}$0"),
            parse_snippet_math({ trig = "oddd", name = "ordinary derivative display" }, "\\odd{$1}{$2}$0"),
            parse_snippet_math({ trig = "od", name = "ordinary derivative inline" }, "\\od{$1}{$2}$0"),
            parse_snippet_math({ trig = "dell", name = "partial symbol" }, "\\del "),

            -- NUMBER SETS WITH DIMENSION
            parse_snippet_math({ trig = "Rnn", name = "R^n" }, "\\RR[${1:n}]$0"),
            parse_snippet_math({ trig = "Cnn", name = "C^n" }, "\\CC[${1:n}]$0"),
            parse_snippet_math({ trig = "Znn", name = "Z^n" }, "\\ZZ[${1:n}]$0"),
            parse_snippet_math({ trig = "Qnn", name = "Q^n" }, "\\QQ[${1:n}]$0"),
            parse_snippet_math({ trig = "Pnn", name = "P^n" }, "\\PP[${1:n}]$0"),

            -- SPECIAL NOTATIONS
            parse_snippet_math({ trig = "deff", name = "defined equals" }, "\\defeq "),
            parse_snippet_math({ trig = "dbox", name = "dashed box" }, "\\dboxed{$1}$0"),
            parse_snippet_math({ trig = "circ", name = "circle around" }, "\\mycir{$1}$0"),
            parse_snippet_math({ trig = "oll", name = "overline" }, "\\ol{$1}$0"),
            parse_snippet_math({ trig = "ull", name = "underline" }, "\\ul{$1}$0"),
            parse_snippet_math({ trig = "wtt", name = "widetilde" }, "\\wt{$1}$0"),
            parse_snippet_math({ trig = "whh", name = "widehat" }, "\\wh{$1}$0"),
          }

          -- ============================================
          -- TEXT MODE SNIPPETS (work anywhere)
          -- ============================================
          local parse_snippet_text = ls.extend_decorator.apply(ls.parser.parse_snippet, {
            -- No condition - works everywhere
          }) --[[@as function]]

          local text_snippets = {
            -- TCOLORBOX ENVIRONMENTS
            parse_snippet_text(
              { trig = "dfn", name = "definition" },
              [[
\dfn{${1:Title}}{$0}
]]
            ),

            parse_snippet_text(
              { trig = "thmm", name = "theorem" },
              [[
\thm{${1:Title}}{$0}
]]
            ),

            parse_snippet_text(
              { trig = "prp", name = "proposition" },
              [[
\mprop{${1:Title}}{$0}
]]
            ),

            parse_snippet_text(
              { trig = "rmdr", name = "reminder" },
              [[
\begin{mybox}{blue}{Reminder!}
	$0
\end{mybox}
]]
            ),

            parse_snippet_text(
              { trig = "clry", name = "corollary" },
              [[
\cor{${1:Title}}{$0}
]]
            ),

            parse_snippet_text(
              { trig = "lmma", name = "lemma" },
              [[
\mlemma{${1:Title}}{$0}
]]
            ),

            parse_snippet_text(
              { trig = "mexr", name = "exercise" },
              [[
\mer{${1:Title}}{$0}
]]
            ),

            parse_snippet_text(
              { trig = "clmm", name = "claim" },
              [[
\clm{${1:Title}}{${2:Label}}{$0}
]]
            ),

            parse_snippet_text({ trig = "exaa", name = "example" }, [[\ex{${1:Title}}{$0}]]),
            parse_snippet_text({ trig = "prf", name = "proof" }, [[\pf{${1:Title}}{$0}]]),

            -- (add commutative diagrams here as shown above)

            -- COMMUTATIVE DIAGRAMS (moved from math_snippets)
            parse_snippet_text(
              { trig = "cd2", name = "2x2 commutative diagram" },
              [[
\begin{tikzcd}
	${1:A} \arrow[r, "${2:f}"] \arrow[d, "${3:g}"'] & ${4:B} \arrow[d, "${5:h}"] \\
	${6:C} \arrow[r, "${7:k}"'] & ${8:D}
\end{tikzcd}$0
]]
            ),

            parse_snippet_text(
              { trig = "cd3", name = "3x3 commutative diagram" },
              [[
\begin{tikzcd}
	${1:A} \arrow[r] \arrow[d] & ${2:B} \arrow[r] \arrow[d] & ${3:C} \arrow[d] \\
	${4:D} \arrow[r] \arrow[d] & ${5:E} \arrow[r] \arrow[d] & ${6:F} \arrow[d] \\
	${7:G} \arrow[r] & ${8:H} \arrow[r] & ${9:I}
\end{tikzcd}$0
]]
            ),

            parse_snippet_text(
              { trig = "cdse", name = "short exact sequence" },
              [[
\begin{tikzcd}
	0 \arrow[r] & ${1:A} \arrow[r, "${2:f}"] & ${3:B} \arrow[r, "${4:g}"] & ${5:C} \arrow[r] & 0
\end{tikzcd}$0
]]
            ),

            parse_snippet_text(
              { trig = "cdpb", name = "pullback diagram" },
              [[
\begin{tikzcd}
	${1:P} \arrow[r] \arrow[d] \arrow[dr, phantom, "\lrcorner", very near start] & ${2:X} \arrow[d, "${3:f}"] \\
	${4:Y} \arrow[r, "${5:g}"'] & ${6:Z}
\end{tikzcd}$0
]]
            ),

            parse_snippet_text(
              { trig = "cdpo", name = "pushout diagram" },
              [[
\begin{tikzcd}
	${1:X} \arrow[r, "${2:f}"] \arrow[d, "${3:g}"'] & ${4:Y} \arrow[d] \\
	${5:Z} \arrow[r] \arrow[ur, phantom, "\ulcorner", very near start] & ${6:P}
\end{tikzcd}$0
]]
            ),

            parse_snippet_text(
              { trig = "cdsq", name = "square diagram" },
              [[
\begin{tikzcd}
	${1:A} \arrow[r, "${2:}"] \arrow[d, "${3:}"'] & ${4:B} \arrow[d, "${5:}"] \\
	${6:C} \arrow[r, "${7:}"'] & ${8:D}
\end{tikzcd}$0
]]
            ),
          } -- Add snippets
          ls.add_snippets("tex", math_snippets, {
            type = "autosnippets",
            default_priority = 200,
          })

          ls.add_snippets("tex", text_snippets, {
            type = "autosnippets",
            default_priority = 200,
          })
        end,
      })
    end,
  },
}
