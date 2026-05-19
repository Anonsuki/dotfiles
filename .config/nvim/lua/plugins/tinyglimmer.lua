return {
	"rachartier/tiny-glimmer.nvim",
	event = "VeryLazy",
	opts = {
		enabled = true,

		-- 1. THE PHYSICS ENGINE
		-- We use "fade" for a sleek, premium look.
		-- Other options like "bounce" or "pulse" are computationally heavier and look like clown vomit.
		default_animation = "fade",
		refresh_interval_ms = 8, -- Ultra-high framerate (roughly 120fps)

		-- 2. THE OPERATION HOOKS
		-- This binds the animation to every core text manipulation
		overwrite = {
			auto_map = true,
			search = { enabled = true },
			paste = { enabled = true },
			undo = { enabled = true },
			redo = { enabled = true },
		},

		-- 3. THE CYBER-NOIR / GRUVBOX AESTHETIC OVERRIDE
		transparency_color = nil, -- Automatically reads your dark background
		animations = {
			fade = {
				max_duration = 350, -- A snappy 350ms fade
				min_duration = 200,
				easing = "outQuad", -- Matches your snacks.scroll physics

				-- We force the glimmer to use the Gruvbox Yellow/Orange
				-- This gives a beautiful "golden glow" when you copy/paste
				default_color = "#fabd2f",
			},
		},
	},
}
