local telescope = require("telescope")
telescope.setup({})

local nvim_lsp = require("lspconfig")

-- python
nvim_lsp.pyright.setup{}

-- typescript
nvim_lsp.tsserver.setup({})

-- lua
nvim_lsp.lua_ls.setup({
  diagnostics = {
    globals = {"vim"}
  }
})

-- TODO: need LSPs for:
-- nix, rust, lua, bash
