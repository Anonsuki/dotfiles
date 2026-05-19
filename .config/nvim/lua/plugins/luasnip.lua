return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter", -- Strategically delays loading until text insertion
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local luasnip = require("luasnip")

		-- 1. Initialize the VSCode-style JSON database
		require("luasnip.loaders.from_vscode").lazy_load()

		-- 2. Initialize personalized, custom Lua snippets
		require("luasnip.loaders.from_lua").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets" },
		})

		-- 3. Engine Parameters
		luasnip.config.set_config({
			history = true,
			update_events = "TextChanged,TextChangedI",
			enable_autosnippets = true,
		})
	end,
}
