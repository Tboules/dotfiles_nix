vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local defaults = { noremap = true, silent = true }

map("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
map("n", "<leader>rr", ":e!<CR>", { desc = "reload buffer" })

-- window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>sp", "<C-w><C-r>", { desc = "Swap Splits" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- vim commands
map("n", "<leader>pv", vim.cmd.Ex)
map("i", "<C-l>", "<esc>la")

map("n", "<leader>w", "<cmd>w<cr>", { desc = "save file" })

map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("v", "J", ":m '>+1<CR>gv=gv", defaults)
map("v", "K", ":m '<-2<CR>gv=gv", defaults)

-- Insert empty line without entering insert mode
map("n", "<leader>o", ':<C-u>call append(line("."), repeat([""], v:count1))<CR>', defaults)
map("n", "<leader>O", ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', defaults)

map("n", "<C-d>", "<C-d>zz", defaults)
map("n", "<C-u>", "<C-u>zz", defaults)
--
-- Obsidian
map("n", "<leader>so", ":Obsidian search<CR>")
map("n", "<leader>tt", ":Obsidian new Calendar/2025/todo_2025 <CR>")
-- map("n", "<leader>nn", ":Obsidian new_from_template {} encounter_template")

map("n", "<leader>nn", function()
	vim.ui.input({ prompt = "New Note Name: " }, function(name)
		if name and name ~= "" then
			vim.cmd("Obsidian new_from_template " .. name .. " encounter_template")
		end
	end)
end)

