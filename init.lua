-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- Load plugins
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
      require("catppuccin").setup()
      vim.cmd[[colorscheme catppuccin]]
    end
  }

  -- Tab bar
  use 'romgrk/barbar.nvim'

  -- File explorer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = 'nvim-tree/nvim-web-devicons', -- for file icons
  }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup{
        options = {
          theme = 'catppuccin',
          component_separators = '',
          section_separators = '',
        },
      }
    end
  }

  -- LSP and autocompletion
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  -- Syntax highlighting with Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'p00f/nvim-ts-rainbow' -- Rainbow parentheses

  -- Git integration
  use 'tpope/vim-fugitive'

  -- Telescope for fuzzy finding
  use 'nvim-telescope/telescope.nvim'

  -- Auto-close brackets and quotes
  use 'jiangmiao/auto-pairs'

  -- Code formatting
  use 'sbdchd/neoformat'

  -- Ruby specific syntax highlighting
  use 'vim-ruby/vim-ruby'
end)

-- nvim-web-devicons setup
require('nvim-web-devicons').setup({
  override = {
    rb = {
      icon = "",
      color = "#ff0000", -- Red color code
      cterm_color = "1", -- Red color code for terminal
      name = "Rb"
    }
  }
})

-- nvim-tree setup
require('nvim-tree').setup({
  view = {
    width = 30,
    side = 'left',
  },
  renderer = {
    highlight_git = true,
    indent_markers = {
      enable = true,
    },
  },
  git = {
    enable = true,
  },
})

-- nvim-cmp setup
local cmp = require'cmp'
cmp.setup({
  -- Complete configuration here
})

-- LSP setup for Ruby using solargraph with diagnostics enabled
require'lspconfig'.solargraph.setup{
  settings = {
    solargraph = {
      diagnostics = true
    }
  }
}

-- Enable LSP-based diagnostics and error detection (red squiggly lines)
vim.diagnostic.config({
  virtual_text = {
    prefix = '●', -- Could be '■', '▎', 'x'
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    source = "always", -- Or "if_many"
  },
})

-- Bufferline (Barbar) setup with error highlighting
require('bufferline').setup{
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        padding = 1
      }
    },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    separator_style = "thin",
  },
  highlights = {
    buffer_selected = {
      guifg = "#FFFFFF",
      guibg = "#282c34",
      gui = "bold"
    },
    diagnostic_selected = {
      guifg = "#ff0000", -- red color for errors
      guibg = "#282c34",
      gui = "bold"
    },
    error_diagnostic_selected = {
      guifg = "#ff0000", -- red color for errors
      guibg = "#282c34",
      gui = "bold"
    },
    error_diagnostic = {
      guifg = "#ff0000", -- red color for errors
      guibg = "#1e222a",
    },
    warning_diagnostic = {
      guifg = "#FFD700", -- yellow color for warnings
      guibg = "#1e222a",
    },
    info_diagnostic = {
      guifg = "#1E90FF", -- blue color for info
      guibg = "#1e222a",
    },
  }
}

-- Key mappings
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', ':NvimTreeFocus<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true, silent = true})

-- Auto-open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end
})

-- Treesitter setup
require'nvim-treesitter.configs'.setup{
  ensure_installed = "all", -- or specify languages you use
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

-- Custom Ruby-specific highlights
vim.api.nvim_set_hl(0, "rubySymbol", { fg = "#c678dd" })
vim.api.nvim_set_hl(0, "rubyStringDelimiter", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "rubyString", { fg = "#e5c07b" })
vim.api.nvim_set_hl(0, "rubyConstant", { fg = "#d19a66" })
vim.api.nvim_set_hl(0, "rubyMethod", { fg = "#61afef" })
