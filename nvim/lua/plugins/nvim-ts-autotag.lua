return {
	"windwp/nvim-ts-autotag",
	lazy = false,
	event = "InsertEnter",
	config = function()
		require("nvim-ts-autotag").setup()
	end,
}

