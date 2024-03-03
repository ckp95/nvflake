require("which-key").setup{} -- show pending keybinds

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

-- bash
nvim_lsp.bashls.setup{}

nvim_lsp.rust_analyzer.setup{}
