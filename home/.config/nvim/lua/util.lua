-- lua/util.lua
local M = {}

---@param repo string
---@return string
function M.gh(repo)
	return "https://github.com/" .. repo
end

---@param keys string
---@param func string|function
---@param desc? string
---@param mode? string|string[]
---@param buff? integer
function M.map(keys, func, desc, mode, buff)
	mode = mode or "n"
	local opts = {
		desc = desc,
	}
	if buff ~= nil then
		opts.buffer = buff
	end
	vim.keymap.set(mode, keys, func, opts)
end

return M
