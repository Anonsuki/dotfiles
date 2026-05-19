return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		lazy = false,
		dependencies = {
			"mfussenegger/nvim-dap",
			{
				"saecki/crates.nvim",
				tag = "stable",
				opts = {},
			},
		},
		config = function()
			vim.g.rustaceanvim = {
				tools = {
					float_win_config = {
						border = "rounded",
					},
					hover_actions = {
						auto_focus = true,
					},
					enable_clippy = true,
				},

				server = {
					on_attach = function(client, bufnr) end,

					default_settings = {
						["rust-analyzer"] = {
							-- FIX IS HERE: Split checkOnSave into boolean + command
							checkOnSave = true,
							check = {
								command = "clippy",
							},

							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},

							procMacro = {
								enable = true,
								ignored = {
									["async-trait"] = { "async_trait" },
									["napi-derive"] = { "napi" },
									["async-recursion"] = { "async_recursion" },
								},
							},

							inlayHints = {
								bindingModeHints = { enable = true },
								chainingHints = { enable = true },
								closingBraceHints = { enable = true, minLines = 25 },
								closureReturnTypeHints = { enable = "always" },
								lifetimeElisionHints = { enable = "always", useParameterNames = true },
								maxLength = 25,
								parameterHints = { enable = true },
								reborrowHints = { enable = "always" },
								renderColons = true,
								typeHints = {
									enable = true,
									hideClosureInitialization = false,
									hideNamedConstructor = false,
								},
							},
						},
					},
				},

				dap = {
					autoload_configurations = true,
				},
			}
		end,
	},

	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				completion = {
					cmp = { enabled = true },
				},
				lsp = {
					enabled = true,
					actions = true,
					completion = true,
					hover = true,
				},
			})
		end,
	},
}
