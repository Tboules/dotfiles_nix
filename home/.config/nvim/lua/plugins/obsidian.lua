local gh = require("util").gh

vim.pack.add({
	{
		src = gh("obsidian-nvim/obsidian.nvim"),
		version = vim.version.range("*"), -- use latest release, remove to use latest commit
	},
	{ src = gh("MeanderingProgrammer/render-markdown.nvim") },
})

require("render-markdown").setup({
	completions = { coq = { enabled = true } },
})

require("obsidian").setup({
	ui = { enable = false },
	legacy_commands = false,
	workspaces = {
		{
			name = "Gnosis",
			path = "~/Documents/vault/gnosis/",
		},
	},
	templates = {
		folder = "Extras/templates",
		date_format = "%Y-%m-%d",
		time_format = "%H:%M",
	},
	daily_notes = {
		folder = "Calendar/2025/daily",
		template = "daily_note.md",
	},
	frontmatter = {
		enabled = false,
	},
	checkbox = {
		order = {
			" ",
			"x",
			">",
		},
	},

	-- New Note
	notes_subdir = "Cards/",
	new_notes_location = "notes_subdir",

	---@param title string|?
	---@return string
	note_id_func = function(title)
		if title ~= nil then
			return title
		else
			return "untitled_note"
		end
	end,
})
