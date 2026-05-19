return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
		"AndreM222/copilot-lualine", -- INJECTED: The Copilot Daemon Monitor
	},

	config = function()
		-- =======================================================
		-- 1. THE CYBER-NOIR PALETTE (Preserved Exactly)
		-- =======================================================
		local colors = {
			black = "#191919",
			allblack = "#000000",
			white = "#d4be98",
			red = "#ff5555",
			green = "#50fa7b",
			blue = "#6272a4",
			yellow = "#EBD28B",
			tan = "#d4be98",
			gray = "#44475a",
			darkgray = "#5B5E5F",
			lightgray = "#282828",
			inactivegray = "#7c7c7c",
		}

		local noir_theme = {
			normal = {
				a = { bg = colors.allblack, fg = colors.white, gui = "bold" },
				b = { bg = colors.darkgray, fg = colors.white },
				c = { bg = colors.black, fg = colors.gray },
			},
			insert = {
				a = { bg = colors.green, fg = colors.black, gui = "bold" },
				b = { bg = colors.darkgray, fg = colors.white },
			},
			visual = {
				a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
				b = { bg = colors.darkgray, fg = colors.white },
			},
			replace = {
				a = { bg = colors.red, fg = colors.black, gui = "bold" },
				b = { bg = colors.darkgray, fg = colors.white },
			},
			command = {
				a = { bg = colors.blue, fg = colors.black, gui = "bold" },
				b = { bg = colors.darkgray, fg = colors.white },
			},
			inactive = {
				a = { bg = colors.black, fg = colors.gray, gui = "bold" },
				b = { bg = colors.black, fg = colors.gray },
				c = { bg = colors.black, fg = colors.gray },
			},
		}

		-- =======================================================
		-- 3. CONFIGURE LUALINE
		-- =======================================================
		require("lualine").setup({
			options = {
				theme = noir_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				-- LEFT SIDE: Mode & Git
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
						icon = " ",
						separator = { left = "", right = "" },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_b = {
					{
						function()
							local icon = require("nvim-web-devicons").get_icon(
								vim.fn.expand("%:t"),
								vim.fn.expand("%:e"),
								{ default = true }
							)
							return icon or " "
						end,
						color = { fg = colors.white, bg = colors.black },
						padding = { left = 1, right = 1 },
						separator = "",
					},
					{
						"filename",
						file_status = true,
						path = 0,
						icons_enabled = false,
						symbols = { modified = "●", readonly = " ", unnamed = "[No Name]" },
						color = { bg = colors.black, fg = colors.tan },
						separator = { right = "" },
						padding = { left = 1, right = 1 },
					},
					{
						function()
							return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						end,
						color = { bg = colors.lightgray, fg = colors.white },
						separator = { right = "" },
					},
					{
						"diff",
						-- INJECTED: O(1) Gitsigns Memory Bypass
						-- This explicitly stops Lualine from running slow shell commands
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
						symbols = { added = " ", modified = " ", removed = " " },
						diff_color = {
							added = { fg = colors.green },
							modified = { fg = colors.yellow },
							removed = { fg = colors.red },
						},
					},
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "  ", warn = "  ", info = "  ", hint = "   " },
						colored = true,
						update_in_insert = true,
						always_visible = false,
						diagnostics_color = {
							error = { fg = colors.red },
							warn = { fg = colors.yellow },
							info = { fg = colors.blue },
							hint = { fg = colors.green },
						},
						color = { bg = "None" },
						padding = { left = 1, right = 1 },
					},
					-- DYNAMIC MACRO RECORDER
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg == "" then
								return ""
							end
							return "  Recording @" .. reg
						end,
						color = { fg = colors.red, gui = "bold" },
						padding = { left = 2, right = 1 },
					},
				},

				-- RIGHT SIDE: Diagnostics, LSP, Location
				lualine_x = {
					-- INJECTED: The headless Copilot daemon monitor
					{
						"copilot",
						show_colors = true,
						show_loading = false,
						symbols = {
							status = {
								icons = {
									enabled = " ", -- The same thing as sleep. This is because I use blimp.cmp, so it messes with it.
									sleep = " ", -- Virtually no difference to it being enabled.
									disabled = " ", -- Visually tells me what is wrong, both with the red color, and the icon.
									warning = " ", -- The same deal as the disabled icon.
									unknown = " ", -- It will remain darkgray when first loading in, so the default icon is used.
								},
								hl = {
									enabled = colors.white,
									sleep = colors.white,
									disabled = colors.red,
									warning = colors.yellow,
									unknown = colors.darkgray,
								},
							},
						},
					},

					{
						function()
							local msg = "No Active Lsp"
							local buf_ft = vim.bo.filetype
							local clients = vim.lsp.get_clients({ bufnr = 0 })
							if next(clients) == nil then
								return msg
							end
							for _, client in ipairs(clients) do
								local filetypes = client.config.filetypes
								if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
									return client.name
								end
							end
							return msg
						end,
						icon = " ",
						color = { fg = colors.darkgray, gui = "bold" },
					},
					{
						"branch",
						icon = " ",
						color = { fg = colors.darkgray, gui = "bold" },
						padding = { left = 2, right = 1 },
					},
				},
				lualine_y = {},
				lualine_z = {
					{
						"location",
						color = { bg = colors.allblack, fg = colors.tan, gui = "bold" },
						separator = { left = "", right = "" },
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			-- INJECTED: Added 'trouble' to properly render statuslines on diagnostic windows
			extensions = { "fugitive", "nvim-tree", "trouble" },
		})
	end,
}
