require("which-key").setup{} -- show pending keybinds
require("ibl").setup{}       -- indent blank line
require("Comment").setup{}   -- comment with gc...

-- workaround to make multi-selection work in telescope
-- taken from https://github.com/nvim-telescope/telescope.nvim/issues/416
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")
local function single_or_multi_select(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local has_multi_selection = (
    next(current_picker:get_multi_selection()) ~= nil
  )

  if has_multi_selection then
    local results = {}
    action_utils.map_selections(
      prompt_bufnr,
      function(selection)
        table.insert(results, selection[1])
      end
    )

      -- load the selections into buffers list without switching to them
    for _, filepath in ipairs(results) do
      -- not the same as vim.fn.bufadd!
      vim.cmd.badd({ args = { filepath } })
    end

    require("telescope.pickers").on_close_prompt(prompt_bufnr)

    -- switch to newly loaded buffers if on an empty buffer
    if vim.fn.bufname() == "" and not vim.bo.modified then
      vim.cmd.bwipeout()
      vim.cmd.buffer(results[1])
    end
    return
  end

  -- if does not have multi selection, open single file
  require("telescope.actions").file_edit(prompt_bufnr)
end

local telescope = require("telescope")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<tab>'] = actions.toggle_selection,
        ['<cr>'] = single_or_multi_select,
      }
    }
  },
  extensions = {
    fzf = {
      fuzzy = false
    }
  }
})
telescope.load_extension("fzf")

require("nvim-treesitter.configs").setup{
  highlight = {
    enable = true
  },
  -- indent = {
  --   enable = true
  -- },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "v",
      node_incremental = "v",
      node_decremental = "V",
    }
  },
}
--
-- completions
local luasnip = require("luasnip")
luasnip.config.setup{}
local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()


local nvim_lsp = require("lspconfig")
nvim_lsp.pyright.setup{capabilities = cmp_capabilities}
nvim_lsp.tsserver.setup({capabilities = cmp_capabilities})
nvim_lsp.lua_ls.setup({
  capabilities = cmp_capabilities,
  settings = { Lua = {
    diagnostics = {
      globals = {"vim"}
    }
  } }
})
nvim_lsp.nil_ls.setup{capabilities = cmp_capabilities}
nvim_lsp.bashls.setup{capabilities = cmp_capabilities}
nvim_lsp.rust_analyzer.setup{capabilities = cmp_capabilities}
nvim_lsp.gopls.setup{capabilities = cmp_capabilities}


