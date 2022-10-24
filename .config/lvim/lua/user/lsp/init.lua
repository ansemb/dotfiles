require("user.lsp.languages.js-ts")
require("user.lsp.languages.rust")

lvim.format_on_save = true
lvim.lsp.diagnostics.virtual_text = false

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "css",
  "javascript",
  "json",
  "jsonc",
  "lua",
  "python",
  "lua",
  "typescript",
  "tsx",
  "rust",
  "java",
  "yaml",
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup {
  { command = "stylua", filetypes = { "lua" } },
}
