local M = {}
local _, comment = pcall(require, "Comment.api")

lvim.keys = {
  normal_mode = {
    ["<C-q>"] = ":q<cr>",
    ["<C-_>"] = comment.toggle.linewise.current,
    ["<C-s>"] = ":w<cr>",
  },

  visual_mode = {
    ["<C-_>"] = "<Plug>(comment_toggle_linewise_visual)",
  },

  visual_block_mode = {
    -- Allow pasting same thing many times
    ["p"] = '""p:let @"=@0<CR>',
  }
}

return M
