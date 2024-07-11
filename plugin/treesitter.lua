local configs = require('nvim-treesitter.configs')

---@diagnostic disable-next-line: missing-fields
configs.setup {
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KiB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
}

vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
