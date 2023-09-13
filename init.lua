local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","

require("lazy").setup({
  'elixir-editors/vim-elixir',
  'vim-ruby/vim-ruby',
  'fatih/vim-go',
  'rust-lang/rust.vim',
  'pangloss/vim-javascript',
  'mxw/vim-jsx',
  'kchmck/vim-coffee-script',
  'pearofducks/ansible-vim',
  'hashivim/vim-terraform',
  'glench/vim-jinja2-syntax',
  'mhinz/vim-mix-format',
  'tpope/vim-rake',
  'tpope/vim-rails',
  'tpope/vim-bundler',
  'tpope/vim-cucumber',
  'tpope/vim-haml',
  'tpope/vim-repeat',
  'tpope/vim-surround',
  --'tpope/vim-endwise',
  'tpope/vim-fugitive',
  'tpope/vim-projectionist',
  --'tpope/vim-dispatch',
  'scrooloose/nerdcommenter',
  --'coderifous/textobj-word-column.vim',
  --'sjl/gundo.vim',
  --'ervandew/supertab',
  'junegunn/fzf',
  'vim-airline/vim-airline',
  'vim-airline/vim-airline-themes',
  'mileszs/ack.vim',
  'jlanzarotta/bufexplorer',
  'scrooloose/nerdtree',
  'kien/ctrlp.vim',
  'altercation/vim-colors-solarized',
  'arcticicestudio/nord-vim',
  'ajmwagar/vim-deus',
  'drewtempelmeyer/palenight.vim',
  'joshdick/onedark.vim',
  'KeitaNakamura/neodark.vim',
  'rakr/vim-one',
  'morhetz/gruvbox',
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/vim-vsnip',
  'hrsh7th/cmp-vsnip',
  'sheerun/vim-polyglot',
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        nextls = {enable = false},
        credo = {enable = true},
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = true,
            enableTestLenses = true,
          },
          on_attach = function(client, bufnr)
            local opts = { noremap=true, silent=true }
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>cd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", opts)
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", opts)
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", opts)
          end,
        }
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  }
})

local cmp = require'cmp'

-- helper functions
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- setting up snippet engine
      -- this is for vsnip, if you're using other
      -- snippet engine, please refer to the `nvim-cmp` guide
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
	cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
	feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
	cmp.complete()
      else
	fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
	cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
	feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'buffer' }
  })
})

vim.cmd('source ~/.vimrc')
