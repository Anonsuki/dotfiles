return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	-- =======================================================
	-- 1. THE DEPENDENCY MANIFEST (Embedded Sub-Plugins)
	-- =======================================================
	dependencies = {
		{
			"ErickKramer/nvim-ros2",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			opts = {
				picker = "snacks",
				autocmds = true,
				treesitter = true,
			},
			keys = {
				{
					"<leader>li",
					function()
						require("nvim-ros2").pickers.interfaces()
					end,
					desc = "[ROS 2]: List interfaces",
				},
				{
					"<leader>ln",
					function()
						require("nvim-ros2").pickers.nodes()
					end,
					desc = "[ROS 2]: List nodes",
				},
				{
					"<leader>la",
					function()
						require("nvim-ros2").pickers.actions()
					end,
					desc = "[ROS 2]: List actions",
				},
				{
					"<leader>lt",
					function()
						require("nvim-ros2").pickers.topics_info()
					end,
					desc = "[ROS 2]: List topics with info",
				},
				{
					"<leader>le",
					function()
						require("nvim-ros2").pickers.topics_echo()
					end,
					desc = "[ROS 2]: List topics with echo",
				},
				{
					"<leader>ls",
					function()
						require("nvim-ros2").pickers.services()
					end,
					desc = "[ROS 2]: List services",
				},
			},
		},
	},

	---@type snacks.Config
	opts = {
		-- =======================================================
		-- 2. CORE SUBSYSTEM ACTIVATION (Memory & UI)
		-- =======================================================
		bigfile = { enabled = true },
		bufdelete = { enabled = true }, -- Activates window split protection
		dashboard = { enabled = true },
		explorer = { enabled = true },
		image = { enabled = true },
		input = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true, debounce = 200 },

		-- =======================================================
		-- 3. THE PHYSICS ENGINE (Animate & Scroll via Libuv)
		-- =======================================================
		animate = {
			enabled = true,
			duration = 20,
			easing = "outQuad",
		},
		scroll = {
			enabled = true,
			animate = {
				duration = { step = 15, total = 250 },
				easing = "outQuad",
			},
		},

		-- =======================================================
		-- 4. THE SPATIAL ISOLATION MATRIX (Zen Mode)
		-- =======================================================
		zen = {
			enabled = true,
			toggles = {
				dim = true,
				git_signs = false,
				mini_diff_signs = false,
				diagnostics = false,
				inlay_hints = false,
			},
			show = {
				statusline = false,
				tabline = false,
			},
			win = { style = "zen" },
		},

		-- =======================================================
		-- 5. THE NOTIFIER ENGINE (Zero-Latency UI Backend)
		-- =======================================================
		notifier = {
			enabled = true,
			timeout = 3000,
			width = { min = 40, max = 60 },
			margin = { top = 1, right = 1, bottom = 0 },
			padding = true,
			sort = { "level", "added" },
			style = "compact",
			top_down = true,
			date_format = "%R",
			refresh = 50,
		},

		-- =======================================================
		-- THE INDENT MATRIX (The "Lighthouse" Binary Weight) TODO Replace this with blink.indent if and only if it is at a stable state to be made use of in place of this.
		-- =======================================================

		-- =======================================================
		-- 2. THE INDENT MATRIX (Properly Nested)
		-- =======================================================
		indent = {
			enabled = true,

			-- The Passive Grid
			indent = {
				char = "▏",
				only_scope = false,
				only_current = false,
				hl = "Comment",
			},

			-- The Active Weight
			scope = {
				enabled = true,
				char = "┃",
				underline = false,
				only_current = false,
				hl = "Normal",
			},

			-- The CPU Guillotine
			chunk = {
				enabled = false,
			},

			animate = {
				enabled = false,
			},

			-- The Exclusion Router
			filter = function(buf)
				local exclude_filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
					"noice",
					"TelescopePrompt",
					"checkhealth",
					"snacks_picker_list",
				}
				local exclude_buftypes = { "terminal", "nofile", "prompt", "quickfix" }

				local ft = vim.bo[buf].filetype
				local bt = vim.bo[buf].buftype

				for _, e_ft in ipairs(exclude_filetypes) do
					if ft == e_ft then
						return false
					end
				end
				for _, e_bt in ipairs(exclude_buftypes) do
					if bt == e_bt then
						return false
					end
				end

				-- snacks.indent also requires these default fallbacks to function properly
				return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and bt == ""
			end,
		}, -- <<< End of the nested indent module	-- =======================================================
		-- 6. THE PICKER ENGINE & GEOMETRY
		-- =======================================================
		picker = {
			enabled = true,
			ui_select = true,
			layout = { preset = "telescope", border = "rounded" },
			formatters = { file = { filename_first = true, truncate = 80 } },
			matcher = { frecency = true, smartcase = true, fuzzy = true },
		},
		pickers = {
			files = {
				hidden = true,
				exclude = { ".git/*", ".next/*", ".svelte-kit/*", "target/*", "node_modules/*" },
			},
			ui_select = { layout = { preset = "dropdown" } },
		},
	},

	-- =======================================================
	-- 7. THE UNIFIED KEYMAP ARCHITECTURE
	-- =======================================================
	keys = {
		-- 1. File & Directory Navigation
		{
			"<leader>jk",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (Hidden, Filtered)",
		},
		{
			"<leader>fb",
			function()
				Snacks.explorer()
			end,
			desc = "File Browser (Explorer Sidebar)",
		},
		{
			"<leader>fz",
			function()
				Snacks.picker.zoxide()
			end,
			desc = "Zoxide Directory Jump",
		},
		{
			"<leader>fm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Search Marks",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find (Buffers + Frecency)",
		},

		-- 2. Content & Diagnostics
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},

		-- 3. LSP Integration
		{
			"<leader>ds",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Document Symbols",
		},
		{
			"<leader>ws",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Workspace Symbols",
		},

		-- 4. Cursor Word Navigation
		{
			"]]",
			function()
				Snacks.words.jump(1, true)
			end,
			desc = "Next Reference (Cursor Word)",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-1, true)
			end,
			desc = "Previous Reference (Cursor Word)",
		},

		-- 5. Git Integration
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit (Full Git UI)",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Commits",
		},

		-- 6. Meta & Plugin Bridges
		{
			"<leader>fv",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Tags",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.pickers()
			end,
			desc = "Builtin Pickers",
		},
		{
			"<leader>st",
			function()
				Snacks.picker.todo_comments()
			end,
			desc = "Search TODOs",
		},
		{
			"<leader>ns",
			function()
				Snacks.picker.snippets()
			end,
			desc = "Browse Snippets",
		},

		-- 7. Deep Work / Cyber-Noir Focus Modes
		{
			"<leader>zz",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>zd",
			function()
				Snacks.dim()
			end,
			desc = "Toggle Dim (Focus Current Scope)",
		},

		-- 8. The Utility Layer (Memory & Spacial Protection)
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratchpad",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratchpad",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Floating Terminal",
		},
		{
			"<c-_>",
			function()
				Snacks.terminal()
			end,
			desc = "which_key_ignore",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer (Preserve Splits)",
		},
		{
			"<leader>go",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Open Line in Browser (GitHub/GitLab)",
			mode = { "n", "v" },
		},
	},
}
