return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "FormatToggle" },

	-- =======================================================
	-- THE 1000% OPTIMAL DECLARATIVE PIPELINE
	-- =======================================================
	opts = {
		-- 1. FORMATTER DAEMONS (The Fast Lane)
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			go = { "goimports-reviser", "gofumpt", "golines" },
			rust = { "rustfmt" },

			-- Web Dev (Daemonized for sub-millisecond execution)
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			vue = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "yamlfmt" },

			-- Scripting (Rust/Go binaries)
			lua = { "stylua" },
			python = { "ruff_format", "ruff_fix" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },

			-- Data & Config
			markdown = { "prettierd", "prettier", stop_after_first = true },
			graphql = { "prettierd", "prettier", stop_after_first = true },
			sql = { "sqlfluff" },
			terraform = { "terraform_fmt" },

			-- Code block injection resolution
			["*"] = { "injected" },
		},

		-- 2. CUSTOM ARGUMENTS
		formatters = {
			injected = { options = { ignore_errors = true } },
			shfmt = { prepend_args = { "-i", "2", "-ci" } },
			sqlfluff = { args = { "fix", "--dialect", "postgres", "-" } },
		},

		-- 3. THE ASYNCHRONOUS ENGINE (Zero UI Blocking)
		notify_on_error = false,

		-- We completely abandon the synchronous format_on_save
		format_on_save = false,

		-- We utilize the background job control API instead
		format_after_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname:match("/node_modules/") then
				return
			end

			return { lsp_format = "fallback" }
		end,
	},

	-- =======================================================
	-- COMMANDS
	-- =======================================================
	init = function()
		-- Global / Buffer Toggle Command
		vim.api.nvim_create_user_command("FormatToggle", function(args)
			local is_global = not args.bang
			if is_global then
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				print("Autoformat (Global): " .. (vim.g.disable_autoformat and "DISABLED" or "ENABLED"))
			else
				vim.b.disable_autoformat = not vim.b.disable_autoformat
				print("Autoformat (Buffer): " .. (vim.b.disable_autoformat and "DISABLED" or "ENABLED"))
			end
		end, { desc = "Toggle autoformat-after-save", bang = true })
	end,
}
