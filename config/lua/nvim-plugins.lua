-- show pending keybinds
require("which-key").setup{}

local telescope = require("telescope")
telescope.setup({
  extensions = {
    fzf = {
      fuzzy = false
    }
  }
})
telescope.load_extension("fzf")

local nvim_lsp = require("lspconfig")

-- python
nvim_lsp.pyright.setup{}

-- typescript
nvim_lsp.tsserver.setup({})

-- lua
nvim_lsp.lua_ls.setup({
  settings = { Lua = {
    diagnostics = {
      globals = {"vim"}
    }
  } }
})

-- nix
nvim_lsp.nil_ls.setup{}

-- TODO: need LSPs for:
-- rust, bash
