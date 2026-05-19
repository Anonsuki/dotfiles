return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")

		mc.setup()

		local set = vim.keymap.set

		-- =======================================================
		-- 1. CORE CURSOR SPAWNING
		-- =======================================================
		-- Add or skip cursors above/below the main cursor
		set({ "n", "v" }, "<C-up>", function()
			mc.lineAddCursor(-1)
		end, { desc = "Add Cursor Above" })
		set({ "n", "v" }, "<C-down>", function()
			mc.lineAddCursor(1)
		end, { desc = "Add Cursor Below" })
		set({ "n", "v" }, "<leader><up>", function()
			mc.lineSkipCursor(-1)
		end, { desc = "Skip Cursor Above" })
		set({ "n", "v" }, "<leader><down>", function()
			mc.lineSkipCursor(1)
		end, { desc = "Skip Cursor Below" })

		-- Add a cursor and jump to the next exact match of the word under cursor
		set({ "n", "v" }, "<leader>n", function()
			mc.matchAddCursor(1)
		end, { desc = "Add Cursor to Next Match" })
		set({ "n", "v" }, "<leader>s", function()
			mc.matchSkipCursor(1)
		end, { desc = "Skip Match & Jump Next" })
		set({ "n", "v" }, "<leader>N", function()
			mc.matchAddCursor(-1)
		end, { desc = "Add Cursor to Prev Match" })

		-- =======================================================
		-- 2. VISUAL BLOCK & REGEX SPAWNING
		-- =======================================================
		-- In visual mode, press 'm' to spawn a cursor on every selected line
		set("v", "m", mc.matchCursors, { desc = "Spawn Cursors on Selection" })

		-- Press 'M' in visual mode to spawn cursors on all regex matches inside the visual block
		set("v", "M", mc.matchCursors, { desc = "Spawn Cursors via Regex in Selection" })

		-- =======================================================
		-- 3. SESSION MANAGEMENT & UI
		-- =======================================================
		-- Press <Esc> to clear all secondary cursors and return to normal editing
		set("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			elseif mc.hasCursors() then
				mc.clearCursors()
			else
				-- Default Neovim escape behavior
				vim.cmd("nohlsearch")
			end
		end)

		-- Bring back cursors if you accidentally cleared them
		set("n", "<leader>gv", mc.restoreCursors, { desc = "Restore Cleared Cursors" })

		-- =======================================================
		-- 4. AESTHETIC OVERRIDE (Gruvbox Alignment)
		-- =======================================================
		-- Force the secondary cursors to map to standard Gruvbox highlights
		local set_hl = vim.api.nvim_set_hl
		set_hl(0, "MultiCursorCursor", { link = "Cursor" })
		set_hl(0, "MultiCursorVisual", { link = "Visual" })
		set_hl(0, "MultiCursorSign", { link = "SignColumn" })
		set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
	end,
}
