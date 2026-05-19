return {
	"okuuva/auto-save.nvim",
	cmd = "ASToggle",
	event = { "InsertLeave", "TextChanged" },
	opts = {
		enabled = true, -- Start enabled

		trigger_events = {
			-- Save immediately if you change buffers or alt-tab (Safe)
			immediate_save = { "BufLeave", "FocusLost" },

			-- Wait for the delay if you are just typing/navigating (The "Undo" Fix)
			defer_save = { "InsertLeave", "TextChanged" },
		},

		-- THE CRITICAL SETTING:
		-- 1000ms = 1 second.
		-- Gives you a "Grace Period" to undo mistakes before writing to disk.
		debounce_delay = 1000,

		-- Don't save Telescope/Harpoon
		condition = function(buf)
			local fn = vim.fn
			local utils = require("auto-save.utils.data")

			if
				fn.getbufvar(buf, "&modifiable") == 1
				and utils.not_in(fn.getbufvar(buf, "&filetype"), { "harpoon", "TelescopePrompt", "neo-tree", "yazi" })
			then
				return true
			end
			return false
		end,

		write_all_buffers = false, -- Only save the file you are actually touching
	},
}
