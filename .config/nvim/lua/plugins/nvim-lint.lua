return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- =======================================================
		-- 1. LINTER MAPPINGS (The "Max Usage" List)
		-- =======================================================
		lint.linters_by_ft = {
			-- WEB DEV
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			css = { "stylelint" },
			scss = { "stylelint" },
			less = { "stylelint" },
			html = { "eslint_d" },
			json = { "jsonlint" },

			-- BACKEND / SYSTEMS
			python = { "ruff" },
			go = { "golangci-lint" },
			-- c and cpp have been intentionally removed. Diagnostics are handled by native LSP (clangd).
			rust = { "clippy" },

			-- INFRASTRUCTURE
			terraform = { "tflint" },
			dockerfile = { "hadolint" },

			-- SHELL
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			zsh = { "shellcheck" },

			-- DATA / CONFIG
			yaml = { "yamllint" },
			["yaml.ghaction"] = { "actionlint" },
			sql = { "sqlfluff" },
			markdown = { "markdownlint" },

			-- GIT
			gitcommit = { "commitlint" },

			-- GLOBAL / MISC
			text = { "codespell" },
		}

		-- =======================================================
		-- 2. CUSTOM TRIGGER LOGIC (Smart GitHub Actions)
		-- =======================================================
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local client = vim.bo.filetype

				if client == "yaml" and string.match(vim.fn.expand("%:p"), ".github/workflows") then
					lint.try_lint("actionlint")
				end

				lint.try_lint()
			end,
		})

		-- =======================================================
		-- 3. KEYMAPS (Manual Trigger)
		-- =======================================================
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
			print("Linting triggered...")
		end, { desc = "Trigger Linting" })
	end,
}
