return {

	"sainnhe/gruvbox-material",

	lazy = false, -- load immediately

	priority = 1000, -- ensure it loads before UI plugins

	config = function()
		-- 1. The Foundation (Transparency & Contrast)

		-- We set these globals BEFORE loading the colorscheme.

		vim.g.gruvbox_material_enable_bold = 1

		vim.g.gruvbox_material_enable_italic = 0

		-- The "Hard" palette is the best for dark mode.

		vim.g.gruvbox_material_background = "hard"

		-- The "Mix" foreground softens the harsh white text to a creamy texture.

		vim.g.gruvbox_material_foreground = "material"

		-- CRITICAL: This enables the WezTerm background to show through.

		-- By setting this to 1, Neovim stops painting a background color.

		vim.g.gruvbox_material_transparent_background = 1

		-- 2. Visual Refinements

		vim.g.gruvbox_material_ui_contrast = "high" -- Makes sidebars/popups distinct

		vim.g.gruvbox_material_float_style = "dim" -- Makes floating windows slightly darker/dimmed

		vim.g.gruvbox_material_statusline_style = "material" -- Matches your lualine bubbles

		-- 3. Diagnostics & Semantics

		vim.g.gruvbox_material_diagnostic_text_highlight = 1

		vim.g.gruvbox_material_diagnostic_line_highlight = 0

		vim.g.gruvbox_material_diagnostic_virtual_text = "colored"

		vim.g.gruvbox_material_better_performance = 1

		-- 4. Load the colorscheme

		vim.cmd.colorscheme("gruvbox-material")

		-- 5. (Optional) Manual Overrides specific to "Ricing"

		-- If you want to customize specific things *after* the theme loads, do it here.

		-- For example, making the Line Numbers slightly brighter:
	end,
}
