return {
	"saghen/blink.cmp",
	version = "*", -- Follows the latest stable release
	build = "cargo build --release",
	-- =======================================================
	-- 1. THE DEPENDENCY MANIFEST (All Plugins Defined Here)
	-- =======================================================
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"ribru17/blink-cmp-spell",
		"moyiz/blink-emoji.nvim",
		"joelazar/blink-calc",
		"mikavilpas/blink-ripgrep.nvim", -- INJECTED: Project-wide asynchronous vocabulary
		"Kaiser-Yang/blink-cmp-git", -- INJECTED: Native Git commit parsing
		{
			"fang2hou/blink-copilot",
			opts = {
				max_completions = 3,
				max_attempts = 4,
				kind_name = "Copilot",
				kind_icon = " ",
				kind_hl = false,
				debounce = 200,
				auto_refresh = { backward = true, forward = true },
			},
		},
	},

	opts = function(_, opts)
		-- =======================================================
		-- 2. GLOBAL CACHE & ENGINE BEHAVIOR
		-- =======================================================
		local icon_map = {
			Copilot = " ",
			Text = "󰉿 ",
			Method = "󰆧 ",
			Function = "󰊕 ",
			Constructor = " ",
			Field = "󰜢 ",
			Variable = "󰀫 ",
			Class = "󰠱 ",
			Interface = " ",
			Module = " ",
			Property = "󰜢 ",
			Unit = "󰑭 ",
			Value = "󰎠 ",
			Enum = " ",
			Keyword = "󰌋 ",
			Snippet = " ",
			Color = "󰏘 ",
			File = "󰈙 ",
			Reference = "󰈇 ",
			Folder = "󰉋 ",
			Constant = "󰏿 ",
			Struct = "󰙅 ",
			Event = " ",
			Operator = "󰆕 ",
			Ripgrep = "󰊄 ",
			Git = "󰊢 ", -- INJECTED: High-performance icons for new sources
		}

		opts.snippets = { preset = "luasnip" }
		opts.appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" }

		-- =======================================================
		-- 3. THE UNIFIED KEYMAP ARCHITECTURE
		-- =======================================================
		opts.keymap = {
			preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<C-k>"] = { "scroll_documentation_up", "fallback" },
			["<C-j>"] = { "scroll_documentation_down", "fallback" },
		}

		-- =======================================================
		-- 4. THE DATA PIPELINE (Strict Filetype & Context Routing)
		-- =======================================================
		opts.sources = opts.sources or {}

		-- INJECTED: Ripgrep added to standard programming flow
		opts.sources.default = { "copilot", "lsp", "path", "snippets", "ripgrep", "buffer", "calc", "spell" }

		opts.sources.per_filetype = {
			markdown = { "lsp", "path", "snippets", "buffer", "dictionary", "thesaurus", "spell", "emoji" },
			text = { "dictionary", "thesaurus", "buffer", "spell" },
			tex = { "lsp", "dictionary", "thesaurus", "buffer", "spell", "calc" },
			typst = { "lsp", "path", "snippets", "buffer", "dictionary", "thesaurus", "spell", "calc" },
			-- INJECTED: Git provider heavily isolated to strictly commit message buffers
			gitcommit = { "git", "buffer", "emoji", "spell", "copilot" },
		}

		opts.sources.providers = {
			copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true },
			calc = { name = "Calc", module = "blink-calc" },
			-- INJECTED: Ripgrep Provider Configuration
			ripgrep = {
				name = "Ripgrep",
				module = "blink-ripgrep",
				score_offset = -10, -- Placed slightly below LSP to prevent overshadowing exact syntax
			},
			-- INJECTED: Git Provider Configuration
			git = {
				name = "Git",
				module = "blink-cmp-git",
			},
			emoji = {
				name = "Emoji",
				module = "blink-emoji",
				score_offset = 15,
				opts = {
					trigger = function()
						return { ":" }
					end,
				},
			},
			spell = {
				name = "Spell",
				module = "blink-cmp-spell",
				opts = {
					enable_in_context = function()
						local curpos = vim.api.nvim_win_get_cursor(0)
						local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
						local in_spell_capture = false
						for _, cap in ipairs(captures) do
							if cap.capture == "spell" then
								in_spell_capture = true
							elseif cap.capture == "nospell" then
								return false
							end
						end
						return in_spell_capture
					end,
				},
			},
		}

		opts.cmdline = opts.cmdline or {}
		opts.cmdline.sources = { "cmdline", "buffer" }
		opts.signature = { enabled = true }

		-- =======================================================
		-- 5. VISUAL RENDERING (The Gruvbox Stealth UI)
		-- =======================================================
		opts.completion = {
			menu = {
				border = "rounded",
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpBorder,CursorLine:BlinkCmpSel,Search:None",
				draw = {
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								local icon = icon_map[ctx.kind] or ctx.kind_icon
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								return "BlinkCmpKind" .. ctx.kind
							end,
						},
						label = {
							width = { fill = true, max = 60 },
							text = function(ctx)
								return ctx.label .. " " .. ctx.label_detail
							end,
							highlight = "BlinkCmpLabel",
						},
						label_description = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDetail",
						},
						source_name = {
							text = function(ctx)
								return "[" .. ctx.source_name .. "]"
							end,
							highlight = "Comment",
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocSel,Search:None",
				},
			},
			ghost_text = { enabled = true },
		}

		return opts
	end,

	-- =======================================================
	-- 6. ENGINE EXECUTION & HIGHLIGHT HOOKS
	-- =======================================================
	config = function(_, opts)
		require("blink.cmp").setup(opts)

		local set_hl = vim.api.nvim_set_hl
		local gray, cream, black, inactive = "#44475a", "#d4be98", "#000000", "#7c7c7c"

		set_hl(0, "BlinkCmpMenu", { bg = black, fg = cream })
		set_hl(0, "BlinkCmpBorder", { bg = black, fg = gray })
		set_hl(0, "BlinkCmpSel", { bg = cream, fg = black, bold = true })
		set_hl(0, "BlinkCmpDoc", { bg = black, fg = cream })
		set_hl(0, "BlinkCmpDocBorder", { bg = black, fg = gray })
		set_hl(0, "BlinkCmpLabel", { fg = cream, bg = "NONE" })
		set_hl(0, "BlinkCmpLabelDetail", { fg = inactive, bg = "NONE", italic = false })

		local kinds = {
			"Copilot",
			"Text",
			"Method",
			"Function",
			"Constructor",
			"Field",
			"Variable",
			"Class",
			"Interface",
			"Module",
			"Property",
			"Unit",
			"Value",
			"Enum",
			"Keyword",
			"Snippet",
			"Color",
			"File",
			"Reference",
			"Folder",
			"EnumMember",
			"Constant",
			"Struct",
			"Event",
			"Operator",
			"TypeParameter",
			"Ripgrep",
			"Git",
		}

		for _, kind in ipairs(kinds) do
			set_hl(0, "BlinkCmpKind" .. kind, { fg = cream, bg = "NONE" })
		end
	end,
}
