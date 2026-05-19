return {
	-- nvim-dap is a dependency, so it's good practice to define it
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Other DAP dependencies like dap-ui, dap-python, etc. can go here
			"theHamsta/nvim-dap-virtual-text",
			"nvim-treesitter/nvim-treesitter", -- recommended dependency
		},
		config = function()
			-- General nvim-dap configuration
			-- ...

			-- Setup nvim-dap-virtual-text
			require("nvim-dap-virtual-text").setup({
				-- Optional configuration options here (see plugin documentation)
				-- e.g., commented = true -- Show virtual text alongside comments
			})

			-- Ensure treesitter parsers are installed for the languages you need
			-- :TSInstall <language> in Neovim
		end,
	},
}
