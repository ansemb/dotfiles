local _, utils = pcall(require, "user.utils")

local M = {
  P = { "<cmd>Telescope projects<CR>", "Projects" },
  t = {
    name = "+Touble",
    t = { "<cmd>TroubleToggle<cr>", "trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
    l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
    r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
  },
  -- t = {
  --   name = "+Trouble",
  --   r = { "<cmd>Trouble lsp_references<cr>", "References" },
  --   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  --   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  --   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  --   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  --   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
  -- },
  S = {
    name = "Session",
    c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
    l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
    Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
  },
  -- l = {
  --   f = {
  --     function()
  --       vim.lsp.format { timeout = 2000 }
  --     end,
  --     "LSP format",
  --   }
  -- }
  f = {
    name = "+Find",
    b = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Current buffer fuzzy-find" },
    f = { require("lvim.core.telescope.custom-finders").find_project_files, "Find File" },
    h = { "<cmd>Telescope help_tags<CR>", "help tags" },
    j = { "<cmd>Telescope zoxide list<CR>", "Zoxide" },
    g = { "<cmd>Telescope live_grep<CR>", "Live grep" },
    r = { "<cmd>Telescope oldfiles<CR>", "Find recent files" },
    m = { "<cmd>Telescope marks<CR>", "Marks" },
    i = {
      name = "+internal",
      c = { "<cmd>Telescope commands<CR>", "commands" },
      h = { "<cmd>Telescope help_tags<CR>", "help tags" },
      m = { "<cmd>Telescope marks<CR>", "Marks" },
      k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
      r = { "<cmd>Telescope registers<CR>", "Registers" },
      C = {
        "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
        "Colorscheme with Preview",
      },
      M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    },
    J = { "<cmd>FindRuntimeFiles<CR>", "Find runtime files" },
    M = { "<cmd>Telescope man_pages<CR>", "Man Pages" },
    P = { "<cmd>Telescope projects<CR>", "Find recent projects" },
    R = { "<cmd>Telescope oldfiles cwd_only=true<CR>", "Find recent files (local)" },
  },
}

lvim.builtin.which_key.mappings = utils.merge_tables(lvim.builtin.which_key.mappings, M)

-- table.insert(table.unpack(M), lvim.builtin.which_key.mappings)
