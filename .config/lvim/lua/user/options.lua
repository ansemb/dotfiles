-- general
lvim.log.level = "warn"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.breadcrumbs.active = true
lvim.builtin.bufferline.active = true
lvim.builtin.dap.active = true
lvim.builtin.notify.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.terminal.active = true
lvim.builtin.theme.options.dim_inactive = true
lvim.builtin.theme.options.style = "storm"
lvim.builtin.treesitter.highlight.enabled = true

lvim.colorscheme = "gruvbox"
lvim.leader = "space"

-- table.insert(lvim.builtin.project.detection_methods, -2, "!>packages")

local options = {
  tabstop = 2,
  relativenumber = true,
  spell = true,
}

vim.opt.spelloptions:append("camel")

for k, v in pairs(options) do
  vim.opt[k] = v
end
