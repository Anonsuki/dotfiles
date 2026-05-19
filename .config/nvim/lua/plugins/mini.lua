return {
	"echasnovski/mini.animate",
	event = "VeryLazy",
	opts = function()
		local animate = require("mini.animate")

		return {
			-- 1. CURSOR ANIMATION (The Kinetic Trail)
			cursor = {
				enable = false,
			},

			-- 2. SCROLL ANIMATION (Forcefully Disabled)
			scroll = {
				enable = false,
			},

			-- 3. WINDOW RESIZE ANIMATION (Smooth Split Gliding)
			resize = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},

			-- 4. WINDOW OPEN/CLOSE ANIMATION (Floating UI Easing)
			open = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
			},
			close = {
				enable = true,
				timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
			},
		}
	end,
}
