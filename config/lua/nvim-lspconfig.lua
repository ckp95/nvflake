local nvim_lsp = require("lspconfig")

-- python
nvim_lsp.pyright.setup{}

-- typescript
nvim_lsp.tsserver.setup({})

-- TODO: need LSPs for:
-- nix, rust, lua, bash

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}), -- what is this for?
  callback = function(ev)
    print("hello from LspAttach")
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
    vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, opts)
    vim.keymap.set("n", "ds", require("telescope.builtin").lsp_document_symbols, opts)
    vim.keymap.set("n", "ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

  end,
})

