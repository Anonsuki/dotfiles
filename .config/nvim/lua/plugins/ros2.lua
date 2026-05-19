return {
	"ErickKramer/nvim-ros2",
	dependencies = {
		-- 1. Dependency Swapped: We remove plenary and telescope
		-- 2. Dependency Injected: We link it directly to the snacks mono-repo
		"folke/snacks.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		-- 3. The Engine Shift: This explicitly tells the ROS 2 plugin
		-- to render its data using the snacks API instead of Telescope
		picker = "snacks",

		autocmds = true,
		treesitter = true,
	},
	keys = {
		-- Your keybinds remain 100% identical; the backend dispatcher handles the translation
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
}
