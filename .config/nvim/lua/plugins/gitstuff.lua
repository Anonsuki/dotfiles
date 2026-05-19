return {
	-- ==========================================
	-- LAYER 1: MICRO-STATE (Gutter & Blame)
	-- ==========================================
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "󰍵" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true,
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			-- Highly optimal debounce to prevent flickering while typing rapidly
			update_debounce = 100,
			max_file_length = 40000, -- Automatically disables on massive files to preserve CPU

			-- Virtual text blame configuration
			current_line_blame = false, -- Keep false by default; toggle on demand
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 500,
			},
		},
	},

	-- ==========================================
	-- LAYER 2: MACRO-STATE (Diff & Merge Conflicts)
	-- ==========================================
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		opts = {
			enhanced_diff_hl = true, -- Uses Treesitter for vastly superior diff coloring
			use_icons = true,
			view = {
				-- Optimize the layout for merge conflicts
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true, -- Shuts off LSP errors during conflicts to reduce noise
				},
			},
		},
	},

	-- ==========================================
	-- LAYER 3: PLATFORM BRIDGE (GitHub PRs & Issues)
	-- ==========================================
	{
		"pwntester/octo.nvim",
		cmd = { "Octo" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.icons",
		},
		opts = {
			enable_builtin = true,
			default_remote = { "upstream", "origin" }, -- Optimally handles forks
			-- Tells Octo to use snacks.picker for its selection menus instead of Telescope
			picker = "snacks",
			picker_config = {
				use_emojis = false, -- Aligns with a clean Gruvbox aesthetic
			},
		},
	},
}
