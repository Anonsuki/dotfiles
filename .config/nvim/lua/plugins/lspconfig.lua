return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim", -- CRITICAL: Adds schemas for JSON/YAML
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			-- Mason Setup
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Capabilities (Blink.cmp integration)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable snippet support (required for some servers like cssls/jsonls)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- ==============================================================================
			-- SERVER CONFIGURATION
			-- ==============================================================================
			local servers = {
				-- ========================
				--        WEB DEV
				-- ========================
				html = {},
				cssls = {},
				tailwindcss = {},
				-- REPLACEMENT: vtsls is faster and smarter than ts_ls
				vtsls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
					},
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
						typescript = {
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					},
				},
				eslint = {
					settings = {
						-- Helps eslint find config files in monorepos
						workingDirectories = { mode = "auto" },
					},
				},
				emmet_ls = {
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
						"vue",
						"eruby",
					},
				},

				-- ========================
				--    MODERN FRAMEWORKS
				-- ========================
				vue_ls = {},
				svelte = {},
				angularls = {},
				graphql = {},

				-- ========================
				--    MOBILE & ENTERPRISE
				-- ========================
				kotlin_language_server = {},
				jdtls = {},

				-- ========================
				--    SYSTEMS / LOW LEVEL
				-- ========================
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = { command = "clippy" },
						},
					},
				},
				zls = {},

				-- UPDATED: gopls with "Max" settings
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},

				-- ========================
				--        SCRIPTING
				-- ========================
				-- REPLACEMENT: basedpyright for Inlay Hints and better type checking
				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								typeCheckingMode = "standard", -- Change to "all" if you want maximum strictness (can be noisy)
							},
						},
					},
				},
				bashls = {},
				lua_ls = {
					settings = {
						Lua = {
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				intelephense = {},
				ruby_lsp = {},

				-- ========================
				--     DATA & SCIENCE
				-- ========================
				julials = {},
				texlab = {},

				-- ========================
				--     DEVOPS & CONFIG
				-- ========================
				dockerls = {},
				terraformls = {},
				ansiblels = {},
				lemminx = {},

				-- UPDATED: JSON with SchemaStore
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},

				-- UPDATED: YAML with SchemaStore
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								-- You must disable built-in schemaStore support if you want to use
								-- this plugin and its advanced options like `ignore`.
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},

				sqlls = {},
				taplo = {}, -- TOML
				marksman = {},

				-- ========================
				--          MISC
				-- ========================
				fortls = {},
				omnisharp = {},
				prismals = {},
				wgsl_analyzer = {},
				astro = {},
				neocmake = {},
			}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_installation = true,
				handlers = {
					function(server_name)
						local config = servers[server_name] or {}
						-- Merge capabilities with Blink
						config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
						require("lspconfig")[server_name].setup(config)
					end,
				},
			})
		end,
	},
}
