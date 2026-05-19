return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text", -- Inline variable text
		"jay-babu/mason-nvim-dap.nvim", -- Bridges Mason & DAP
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- =======================================================
		-- 1. ICONS & SIGNS (Make it look good)
		-- =======================================================
		local signs = {
			DapBreakpoint = { text = "●", texthl = "DapBreakpoint" },
			DapBreakpointCondition = { text = "●", texthl = "DapBreakpointCondition" },
			DapLogPoint = { text = "◆", texthl = "DapLogPoint" },
			DapStopped = { text = "➜", texthl = "DapStopped" },
			DapBreakpointRejected = { text = " ", texthl = "DapBreakpointRejected" },
		}
		for type, icon in pairs(signs) do
			vim.fn.sign_define(type, { text = icon.text, texthl = icon.texthl, linehl = "", numhl = "" })
		end

		-- =======================================================
		-- 2. MASON INTEGRATION (Automatic Setup)
		-- =======================================================
		require("mason-nvim-dap").setup({
			-- Ensures these adapters are always installed
			ensure_installed = { "codelldb", "debugpy", "delve" },

			-- AUTOMATIC HANDLERS: This replaces your manual setup!
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,

				-- CUSTOM HANDLER FOR CODELLDB (C/C++/Rust)
				codelldb = function(config)
					config.adapters = {
						type = "server",
						port = "${port}",
						executable = {
							command = "codelldb", -- Mason puts this in path automatically
							args = { "--port", "${port}" },
						},
					}
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})

		-- =======================================================
		-- 3. LANGUAGE CONFIGURATIONS (The "Run" profiles)
		-- =======================================================

		-- C / C++ / Rust
		local cpp_config = {
			{
				name = "Launch File",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
		dap.configurations.c = cpp_config
		dap.configurations.cpp = cpp_config
		dap.configurations.rust = cpp_config

		-- =======================================================
		-- 4. UI SETUP (DapUI & Virtual Text)
		-- =======================================================
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Enable Virtual Text (Inline values)
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = true,
			show_stop_reason = true,
			commented = false, -- show virtual text next to code, not as comment
		})

		-- Auto-open UI listeners
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- =======================================================
		-- 5. KEYMAPS (The "Max Usage" workflow)
		-- =======================================================
		local map = vim.keymap.set
		map("n", "<F5>", function()
			dap.continue()
		end, { desc = "Debugger: Continue" })
		map("n", "<F10>", function()
			dap.step_over()
		end, { desc = "Debugger: Step Over" })
		map("n", "<F11>", function()
			dap.step_into()
		end, { desc = "Debugger: Step Into" })
		map("n", "<F12>", function()
			dap.step_out()
		end, { desc = "Debugger: Step Out" })

		map("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "Debugger: Toggle Breakpoint" })
		map("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debugger: Conditional Breakpoint" })
		map("n", "<leader>du", function()
			dapui.toggle()
		end, { desc = "Debugger: Toggle UI" })
	end,
}
