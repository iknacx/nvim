vim.opt.packpath:prepend("@vim-pack-dir@")
vim.opt.runtimepath:prepend("@vim-pack-dir@")

local config = vim.fn.stdpath "config"
vim.opt.packpath:remove(config)
vim.opt.runtimepath:remove(config)
vim.opt.runtimepath:remove(config .. "/after")

config = "@nvix-path@"
vim.g.nvix_path = config
vim.opt.packpath:prepend(config)
vim.opt.runtimepath:prepend(config)
vim.opt.runtimepath:append(config .. "/after")

local M = {}

local ok, table = pcall(vim.fn.json_decode, [[@plugin-json@]])
if ok then
  M.plugins = table
else
  vim.notify("Could not parse the plugin table json", vim.log.levels.ERROR)
end

M.__grammar_path = "@grammar-path@"

M.__early_init_path = vim.fn.expand("<sfile>:p")
M.__early_init = function()
  dofile(config .. "/init.lua")
end

_G.nvix = M 
package.preload["nvix"] = M

