return {
	"MagicDuck/grug-far.nvim",
	opts = {
		-- 1. Engine & Performance
		engine = "ripgrep",

		-- 2. Visual Optimization (Matching the modern UI)
		windowCreationCommand = "split",
		keymaps = {
			replace = "<C-Enter>",
			qflist = "<C-q>",
			syncLocations = "<C-s>",
			syncLine = "<C-l>",
			close = "q",
			historyOpen = "<C-h>",
			historyAdd = "<C-a>",
			refresh = "<C-r>",
			openLocation = "<Enter>",
			openNextLocation = "<down>",
			openPrevLocation = "<up>",
			gotoLocation = "<Enter>",
			pickHistoryEntry = "<Enter>",
			abort = "<C-c>",
			help = "g?",
			toggleShowCommand = "<C-p>",
			swapEngine = "<C-e>",
		},
	},
	keys = {
		-- ==========================================
		-- THE PROJECT-WIDE REFACTORING PIPELINE
		-- ==========================================
		{
			"<leader>sr",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						-- Automatically restricts the search to the file type you are currently editing
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace (Project Wide)",
		},
		{
			"<leader>sw",
			function()
				require("grug-far").open({
					transient = true,
					-- Instantly populates the search field with the exact word under your cursor
					prefills = { search = vim.fn.expand("<cword>") },
				})
			end,
			mode = { "n", "v" },
			desc = "Search and Replace (Word Under Cursor)",
		},
	},
}
