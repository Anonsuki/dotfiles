return {
	"nvim-treesitter/nvim-treesitter",
	version = false,
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		{ "windwp/nvim-ts-autotag", opts = {} },
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- =======================================================
		-- SAFETY CHECK: Stop crash if plugin isn't installed yet!
		-- =======================================================
		local status_ok, configs = pcall(require, "nvim-treesitter.configs")
		if not status_ok then
			return
		end

		configs.setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"luadoc",
				"jsdoc",
				"comment",
				"rust",
				"cpp",
				"python",
				"zig",
				"html",
				"css",
				"javascript",
				"latex",
				"typst",
				"typescript",
				"tsx",
				"json",
				"yaml",
				"toml",
				"xml",
				"sql",
				"graphql",
				"java",
				"kotlin",
				"swift",
				"go",
				"bash",
				"fish",
				"dockerfile",
				"terraform",
				"make",
				"cmake",
				"git_config",
				"gitcommit",
				"gitignore",
				"diff",
				"regex",
				"http",
				"jq",
			},

			sync_install = false,
			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = { enable = true },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = { ["]m"] = "@function.outer", ["]c"] = "@class.outer" },
					goto_next_end = { ["]M"] = "@function.outer", ["]C"] = "@class.outer" },
					goto_previous_start = { ["[m"] = "@function.outer", ["[c"] = "@class.outer" },
					goto_previous_end = { ["[M"] = "@function.outer", ["[C"] = "@class.outer" },
				},
			},
		})

		require("treesitter-context").setup({
			enable = true,
			max_lines = 5,
			trim_scope = "outer",
		})
	end,
}
