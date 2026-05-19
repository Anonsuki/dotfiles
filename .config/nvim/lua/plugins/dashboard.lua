return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		dashboard = {
			preset = {
				header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                ]],
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					-- UPDATED: Changed key from "L" to "l" per your request
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },

				{ section = "keys", indent = 2, padding = 1 },

				{ section = "startup" },
			},
		},
	},
	config = function(_, opts)
		local snacks = require("snacks")
		snacks.setup(opts)

		-- Function to force the colors
		local function set_dashboard_colors()
			local red = "#DC143C"
			-- Force these groups to be RED, overriding the theme
			vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = red, bold = true })
			vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = red })
			vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = red })
			vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = red })
			vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = red })
			vim.g.gruvbox_material_transparent_background = 1
		end

		-- 1. Apply colors immediately
		set_dashboard_colors()

		-- 2. Create an Autocommand to RE-APPLY colors whenever the colorscheme loads/changes
		--    This prevents Gruvbox from resetting your red text back to orange.
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_dashboard_colors,
		})
	end,
}
