local gh = require("util").gh

vim.pack.add({
	gh("nvim-tree/nvim-web-devicons"),
	gh("nvim-lualine/lualine.nvim"),
})

require("lualine").setup({
	options = {
		theme = "nightfox",
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_a = {
			{
				"filename",
				path = 1,
			},
		},
	},
})
