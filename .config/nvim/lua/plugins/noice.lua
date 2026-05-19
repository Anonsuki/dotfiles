return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = {
		-- ==========================================
		-- 0. THE ZERO-LATENCY ROUTER (Snacks Backend)
		-- ==========================================
		notify = {
			enabled = true,
			view = "notify",
		},

		-- ==========================================
		-- 1. THE "RICE" PRESETS & FORMATTING
		-- ==========================================
		presets = {
			bottom_search = false, -- SPATIAL PIVOT: Forces searches into the central floating palette
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = true,
		},

		cmdline = {
			format = {
				-- Dynamic Iconography Pipeline
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = " ", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
			},
		},

		-- ==========================================
		-- 2. LSP INTEGRATION & TELEMETRY
		-- ==========================================
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = { enabled = true, silent = false },
			signature = {
				enabled = true,
				auto_open = { enabled = true, trigger = true, luasnip = true, throttle = 50 },
			},
			progress = {
				enabled = true,
				-- Formats the built-in LSP progress ring
				format = "lsp_progress",
				format_done = "lsp_progress_done",
				throttle = 1000 / 30, -- 30fps refresh rate for the spinning icon
			},
		},

		-- ==========================================
		-- 3. VISUAL CUSTOMIZATION (Alpha Compositing)
		-- ==========================================
		views = {
			cmdline_popup = {
				position = { row = 5, col = "50%" },
				size = { width = 60, height = "auto" },
				border = { style = "rounded", padding = { 0, 1 } },
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,FloatTitle:NoiceCmdlinePopupTitle",
					winblend = 10, -- Mathematically applies a 10% frosted-glass transparency
				},
			},
			popupmenu = {
				relative = "editor",
				position = { row = 8, col = "50%" },
				size = { width = 60, height = 10 },
				border = { style = "rounded", padding = { 0, 1 } },
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:NoiceCmdlinePopupBorder,FloatTitle:NoiceCmdlinePopupTitle",
					winblend = 10, -- 10% transparency for the autocomplete dropdown
				},
			},
		},

		-- ==========================================
		-- 4. ROUTING (The "Silence" & Telemetry Direction)
		-- ==========================================
		routes = {
			-- Hide "written" file save messages
			{ filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
			-- Hide "No information available" LSP hover errors
			{ filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
			-- Hide "E486: Pattern not found" search errors
			{ filter = { event = "msg_show", find = "E486" }, opts = { skip = true } },

			-- TELEMETRY ROUTING: Force all LSP progress into the unobtrusive 'mini' view
			{
				filter = { event = "lsp", kind = "progress" },
				view = "mini",
			},
		},
	},

	-- ==========================================
	-- 5. AESTHETIC OVERRIDE (The Stealth Grey Crush)
	-- ==========================================
	config = function(_, opts)
		require("noice").setup(opts)

		vim.notify = function(msg, level, notify_opts)
			return Snacks.notifier.notify(msg, level, notify_opts)
		end

		local function set_noice_colors()
			local set_hl = vim.api.nvim_set_hl
			local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
			local comment_fg = comment_hl.fg or comment_hl.foreground

			set_hl(0, "GruvboxGreyCmd", { fg = comment_fg, bg = "NONE" })
			set_hl(0, "NoiceCmdlinePopupBorder", { link = "GruvboxGreyCmd" })
			set_hl(0, "NoiceCmdlinePopupTitle", { link = "GruvboxGreyCmd" })
			set_hl(0, "NoiceCmdlineIcon", { link = "GruvboxGreyCmd" })
			set_hl(0, "NoiceCmdlinePopupBorderCmdline", { link = "GruvboxGreyCmd" })
			set_hl(0, "NoiceCmdlineIconCmdline", { link = "GruvboxGreyCmd" })
		end

		set_noice_colors()
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_noice_colors,
		})
	end,
}
