return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- Load only when a markdown file is opened to preserve startup speed
	ft = { "markdown", "markdown.mdx", "codecompanion" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons", -- Ensures modern icon rendering
	},
	opts = {
		-- 1. HEADING GEOMETRY
		heading = {
			enabled = true,
			sign = false, -- Disables the left-hand column sign to keep the gutter clean
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			position = "overlay", -- Replaces the '#' characters directly
			width = "full", -- Extends the header background color across the entire screen width
		},

		-- 2. CHECKBOX & LIST RENDERING
		checkbox = {
			enabled = true,
			position = "inline",
			unchecked = { icon = "󰄱 " },
			checked = { icon = "󰱒 " },
			custom = {
				-- Allows for custom states like [~] for "in progress"
				todo = { raw = "[~]", rendered = "󰔧 ", highlight = "DiagnosticWarn" },
			},
		},
		bullet = {
			icons = { "●", "○", "◆", "◇" },
			right_pad = 1,
		},

		-- 3. LATEX & MATH SUPPORT
		latex = {
			enabled = true,
			-- Renders complex math equations dynamically if you use LaTeX inside your markdown
			render_modes = { "n", "c" },
			top_pad = 0,
			bottom_pad = 0,
		},

		-- 4. TABLE FORMATTING
		-- Perfect synergy with dhruvasagar/vim-table-mode
		table = {
			enabled = true,
			position = "overlay",
		},
	},
}
