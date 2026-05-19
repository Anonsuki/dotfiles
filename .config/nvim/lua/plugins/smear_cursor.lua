return {
	"sphamba/smear-cursor.nvim",
	opts = {
		-- ==========================================
		-- 1. RENDERING ENGINE & CONTEXT
		-- ==========================================
		legacy_computing_symbols_support = true,
		smear_between_buffers = true,
		smear_between_neighbor_lines = true,
		scroll_buffer_space = true,

		-- ==========================================
		-- 2. KINEMATICS & VISCOSITY (The Liquid Feel)
		-- ==========================================
		stiffness = 0.8, -- High responsiveness for the leading edge
		trailing_stiffness = 0.25, -- Viscous, heavy drag for the tail
		stiffness_insert_mode = 0.9, -- Ultra-snappy for precise typing
		trailing_stiffness_insert_mode = 0.6, -- Shorter, less distracting tail while typing
		damping = 0.7, -- Heavy damping for a premium, bounce-free stop
		trailing_exponent = 4, -- Elegant, sharp taper to the fading tail

		-- ==========================================
		-- 3. TARGET BEHAVIOR
		-- ==========================================
		never_draw_over_target = false, -- Allows the cursor to fully eclipse the text naturally
		hide_target_hack = false, -- Disabled by default to prevent colorscheme flickering
	},
}
