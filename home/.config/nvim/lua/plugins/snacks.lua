local map = require("util").map
vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
	dashboard = {
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	picker = {
		layout = "ivy_split",
	},
	input = {},
	explorer = {},
	notifier = {},
	indent = {},
})
map("e", function()
	Snacks.explorer()
end, "File Explorer")
map("<leader>sf", Snacks.picker.files, "Find Files")
map("<leader>sg", Snacks.picker.grep, "Live grep")
map("<leader><space>", Snacks.picker.smart, "Find buffers")
map("<leader>gf", Snacks.picker.git_files, "Find Git Files")
map("<leader>sw", Snacks.picker.grep_word, "Visual selection or word", { "n", "x" })
map("<leader>sh", Snacks.picker.help, "Find Help")
-- -- Top Pickers & Explorer
--   { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
--   { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
--   { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
--   { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
--   { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
--   { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
--   -- find
--   { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
--   { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
--   { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
--   { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
--   { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
--   { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
--   -- git
--   { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
--   { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
--   { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
--   { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
--   { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
--   { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
--   { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
--   -- gh
--   { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
--   { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
--   { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
--   { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
--   -- Grep
--   { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
--   { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
--   { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
--   { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
--   -- search
--   { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
--   { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
--   { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
--   { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
--   { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
--   { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
--   { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
--   { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
--   { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
--   { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
--   { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
--   { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
--   { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
--   { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
--   { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
--   { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
--   { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
--   { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
--   { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
--   { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
--   { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
--   -- LSP
--   { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
--   { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
--   { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
--   { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
--   { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
--   { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
--   { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
--   { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
--   { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
--
-- 		vim.keymap.set("n", "<leader>/", function()
-- 			-- You can pass additional configuration to telescope to change theme, layout, etc.
-- 			require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
-- 				winblend = 0,
-- 				previewer = false,
-- 			}))
-- 		end, { desc = "[/] Fuzzily search in current buffer" })
--
-- 		vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
-- 		vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
--
-- 		vim.keymap.set("n", "<leader>ss", function()
-- 			require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
-- 		end, { desc = "[S]earch [S]ecret Files" })
--
-- 		vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>sw",
-- 			require("telescope.builtin").grep_string,
-- 			{ desc = "[S]earch current [W]ord" }
-- 		)
-- 		vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
-- 		vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on Git Root" })
-- 		vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
-- 		vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
-- 	end,
-- }
