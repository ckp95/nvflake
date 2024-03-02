-- TODO: fzf integration

local telescope = require("telescope")
telescope.setup({})

local nvim_lsp = require("lspconfig")

-- python
nvim_lsp.pyright.setup{}

-- typescript
nvim_lsp.tsserver.setup({})

-- TODO: need LSPs for:
-- nix, rust, lua, bash
