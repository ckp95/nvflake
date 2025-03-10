local telescope = require("telescope")
telescope.setup({
    defaults = {
        layout_strategy = "flex",
        layout_config = {
            flip_columns = 190,
            preview_cutoff = 25,
        }
    }
})

local nmap = function(lhs, rhs, desc)
  return vim.keymap.set(
    "n", lhs, rhs, { desc = desc }
  )
end

nmap("<leader>ff",
     require('telescope.builtin').find_files,
     "[ff] Find files")
nmap("<leader>fs",
     require('telescope.builtin').grep_string,
     "[fs] Grep files for string under cursor")
nmap("<leader>fg",
     require('telescope.builtin').live_grep,
     "[fg] Live-grep files")
nmap("<leader><space>",
     require('telescope.builtin').buffers,
     "[ ] Find existing buffers")
nmap("<leader>fr",
     require('telescope').extensions.recent_files.pick,
     "[fr] Find recent files")
nmap("<leader>fh",
     require('telescope.builtin').help_tags,
     "[fh] Find help")
nmap("<leader>fk",
     require('telescope.builtin').keymaps,
     "[fk] Find keymaps")
nmap("<leader>/",
     require('telescope.builtin').current_buffer_fuzzy_find,
     "[/] Find in buffer")
nmap("<leader>ee",
  vim.diagnostic.open_float,
  "[e]xpand [e]rror")

-- TODO find in current buffer

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}), -- what is this for?
  callback = function(ev)
    -- local client_name = vim.lsp.get_client_by_id(ev.data.client_id).name
    -- vim.notify("LspAttach: " .. client_name)

    local nmap = function(lhs, rhs, desc)
      return vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = ev.buf })
    end
    nmap("gd",
      require("telescope.builtin").lsp_definitions,
      "[g]oto [d]efinition")
    nmap("gD",
      vim.lsp.buf.declaration,
      "[g]oto [D]eclaration")
    nmap("<leader>D",
      vim.lsp.buf.type_definition,
      "goto type [D]definition")
    nmap("K", -- double-tap to jump into the window for scrolling etc
      vim.lsp.buf.hover,
      "hover documentation")
    nmap("<leader>r",
      vim.lsp.buf.rename,
      "[r]ename")
    nmap("<leader>ca",
      vim.lsp.buf.code_action,
      "[c]ode [a]ction")
    nmap("gr",
      require("telescope.builtin").lsp_references,
      "[g]oto [r]eferences")
    nmap("gI",
      require("telescope.builtin").lsp_implementations,
      "[g]oto [I]implementations")
    nmap("<leader>ss",
      require("telescope.builtin").lsp_document_symbols,
      "[s]ymbol[s] in document")
    nmap("<leader>sw",
      require("telescope.builtin").lsp_dynamic_workspace_symbols,
      "[s]ymbols in [w]orkspace")
    nmap("<leader>fe",
      function ()
          return require("telescope.builtin").diagnostics({bufnr = 0})
      end,
      "[f]ind [e]rrors in buffer")
    nmap("<leader>fE",
      require("telescope.builtin").diagnostics,
      "[f]ind [E]rrors in workspace")
  end,
})


