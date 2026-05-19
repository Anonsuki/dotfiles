return {
	"mrjones2014/smart-splits.nvim",
	-- Using the 'keys' table allows Lazy.nvim to defer loading the plugin
	-- until you actually press one of these combinations, saving startup time.
	keys = {
		-- =========================================================
		-- 1. Spatial Movement (Matches WezTerm CTRL modifier)
		-- =========================================================
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
			desc = "Move to left split/pane",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			desc = "Move to below split/pane",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			desc = "Move to above split/pane",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			desc = "Move to right split/pane",
		},

		-- =========================================================
		-- 2. Precision Resizing (Matches WezTerm META/ALT + Arrow Keys)
		-- =========================================================
		{
			"<A-Left>",
			function()
				require("smart-splits").resize_left()
			end,
			desc = "Resize split left",
		},
		{
			"<A-Down>",
			function()
				require("smart-splits").resize_down()
			end,
			desc = "Resize split down",
		},
		{
			"<A-Up>",
			function()
				require("smart-splits").resize_up()
			end,
			desc = "Resize split up",
		},
		{
			"<A-Right>",
			function()
				require("smart-splits").resize_right()
			end,
			desc = "Resize split right",
		},
	},
}
