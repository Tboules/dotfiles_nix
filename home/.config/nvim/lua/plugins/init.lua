  -- lua/tony/plugins/init.lua
  local plugins_dir = vim.fn.stdpath("config") .. "/lua/plugins"
  for name, type in vim.fs.dir(plugins_dir) do
    if type == "file" and name:match("%.lua$") and name ~= "init.lua" then
      require("plugins." .. name:gsub("%.lua$", ""))
    end
  end
