local telescope = require("telescope")
telescope.setup({})

local nmap = function(lhs, rhs, desc)
  return vim.keymap.set(
    "n", lhs, rhs, { desc = desc }
  )
end

nmap("<leader>ff",
     require('telescope.builtin').find_files,
     "[ff] Find files")
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
