return {
	"windwp/nvim-autopairs",
	event = "InsertEnter", -- Zero startup cost. Only boots when you enter Insert mode.
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		-- =======================================================
		-- 1. THE CORE PHYSICS ENGINE
		-- =======================================================
		npairs.setup({
			check_ts = true,
			ts_config = {
				-- Treesitter Blacklists: Halts the engine inside these specific nodes
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				python = { "string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },

			-- Standard IDE Logic: Do not auto-pair if the next character is alphanumeric
			ignored_next_char = "[%w%.]",

			-- Instantly forces the closing pair to the same Z-index as the cursor
			enable_check_bracket_line = true,

			-- =======================================================
			-- 2. THE FAST-WRAP MATRIX
			-- =======================================================
			-- Usage: Type `(`, then press `<M-e>` (Alt+E) to instantly wrap existing text
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		})

		-- =======================================================
		-- 3. THE SPACING EXPANSION RULES (Custom Lua Injection)
		-- =======================================================
		-- Converts (|) -> ( | ) when you press the spacebar
		local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
		npairs.add_rules({
			Rule(" ", " ")
				:with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({ "()", "[]", "{}" }, pair)
				end)
				:with_move(cond.none())
				:with_cr(cond.none())
				:with_del(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local context = opts.line:sub(col - 1, col + 2)
					return vim.tbl_contains({ "(  )", "[  ]", "{  }" }, context)
				end),
			Rule("", " )")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == ")"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key(")"),
			Rule("", " ]")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == "]"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key("]"),
			Rule("", " }")
				:with_pair(cond.none())
				:with_move(function(opts)
					return opts.char == "}"
				end)
				:with_cr(cond.none())
				:with_del(cond.none())
				:use_key("}"),
		})
	end,
}
