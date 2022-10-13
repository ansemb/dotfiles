local M = {}

lvim.keys = {
  normal_mode = {
    ["<C-q>"] = ":q<cr>",
    ["<C-_>"] = "<Plug>(comment_toggle_linewise_current)",
    ["<C-s>"] = ":w<cr>",
    ["<S-l>"] = ":BufferLineCycleNext<cr>",
    ["<S-h>"] = ":BufferLineCyclePrev<cr>",
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
