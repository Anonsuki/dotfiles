return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- FIXED: Used built-in 'jit.os' instead of missing 'utils' module
		if jit.os == "Linux" then
			vim.g.vimtex_view_method = "zathura"
		elseif jit.os == "OSX" then
			vim.g.vimtex_view_method = "skim"
		else
			-- Fallback for other systems (like Windows/BSD)
			vim.g.vimtex_view_method = "zathura"
		end

		vim.g.vimtex_view_mupdf_sync = 1
		vim.g.vimtex_view_mupdf_activate = 1
		vim.g.vimtex_quickfix_mode = 0
		-- vim.g.tex_conceal = "abdmg"
	end,
}
