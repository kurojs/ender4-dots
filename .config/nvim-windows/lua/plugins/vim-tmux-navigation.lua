-- This file contains the configuration for the nvim-tmux-navigation plugin in Neovim.

return {
  -- Plugin: nvim-tmux-navigation
  -- URL: https://github.com/alexghergh/nvim-tmux-navigation
  -- Description: A Neovim plugin that allows seamless navigation between Neovim and tmux panes.
  -- NOTE: Disabled on Windows since tmux is not available
  "alexghergh/nvim-tmux-navigation",
  enabled = vim.fn.has("win32") ~= 1,
}
