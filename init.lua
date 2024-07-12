local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '
g.editorconfig = true


if fn.has('termguicolors') then
  opt.termguicolors = true
end


opt.path = opt.path .. '**'

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.incsearch = true
opt.hlsearch = false
opt.wrap = false

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

opt.foldenable = true

opt.backup = false
opt.swapfile = false

opt.undofile = true
opt.undodir = fn.stdpath("data") .. "/undodir"

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.colorcolumn = '100'
opt.showmode = false

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]


local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = '󰅚',
      [vim.diagnostic.severity.WARN] = '⚠',
      [vim.diagnostic.severity.INFO] = 'ⓘ',
      [vim.diagnostic.severity.HINT] = '󰌶',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}


cmd.packadd('cfilter')

vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')
