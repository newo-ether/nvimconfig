local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup({
    {
        "lunarvim/darkplus.nvim"
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function ()
            require("bufferline").setup({
                options = {
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "File Explorer",
                            text_align = "center",
                            highlight = "Directory",
                            separator = true
                        }
                    },
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        if level == "error" then
                            return "󰅚 "..count
                        elseif level == "warning" then
                            return "󰀪 "..count
                        else
                            return "󰌶 "..count
                        end
                    end,
                }
            })
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function ()
            require("lualine").setup({})
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim"
        },
        config = function ()
            require("neo-tree").setup({
                window = {
                    popup = {
                        position = "20%"
                    }
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function ()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {"c", "cpp", "rust", "python", "lua", "vim", "vimdoc"},
                auto_install = true,
                highlight = {
                    enable = true
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function ()
            local lspconfig = require("lspconfig")
            lspconfig.clangd.setup({})
            lspconfig.pylsp.setup({})
            lspconfig.lua_ls.setup({})
            lspconfig.rust_analyzer.setup({})
        end
    },
    {
	    "L3MON4D3/LuaSnip",
	    version = "v2.*",
	    build = "make install_jsregexp"
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            "rafamadriz/friendly-snippets",
            "onsails/lspkind-nvim"
        },
        config = function ()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local select_opts = {behavior = cmp.SelectBehavior.Select}

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                sources = {
                    {name = "path"},
                    {name = "nvim_lsp"},
                    {name = "buffer"},
                    {name = "luasnip"},
                },
                mapping = {
                    ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
                    ["<Down>"] = cmp.mapping.select_next_item(select_opts),
                    ["<CR>"] = cmp.mapping.confirm({select = false})
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                }
            })
        end
    },
    {
        "numToStr/Comment.nvim",
        config = function ()
            require("Comment").setup({})
        end
    },
    {
        "akinsho/toggleterm.nvim",
        config = function ()
            require("toggleterm").setup({})
        end
    },
    {
        "folke/edgy.nvim",
        opts = {
            bottom = {
                {
                    ft = "toggleterm"
                }
            },
            left = {
                {
                    ft = "neo-tree"
                }
            }
        }
    },
    {
        "karb94/neoscroll.nvim",
        config = function ()
            require("neoscroll").setup({})
        end
    }
})

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.mouse = 'a' -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4 -- number of visual spaces per TAB
vim.opt.softtabstop = 4 -- number of spacesin tab when editing
vim.opt.shiftwidth = 4 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python
vim.opt.smartindent = true
vim.opt.autoindent = true

-- UI config
vim.cmd("colorscheme darkplus")
vim.cmd("set scrolloff=1")
vim.cmd("set clipboard+=unnamedplus")
vim.opt.number = true -- show absolute number
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

-- Key mapping
local opts = {
    noremap = true,
    silent = true
}

vim.g.mapleader = "	"
vim.g.maplocalleader = "	"

local map = vim.api.nvim_set_keymap

map("n", "<leader>w", "<C-w>w", opts)
map("n", "<leader>q", ":Neotree close<CR>:q<CR>", opts)
map("n", "<leader>f", ":Neotree toggle<CR>", opts)
map("n", "<leader>s", ":ToggleTerm<CR>", opts)
map("n", "<leader>v", ":edit ~/.config/nvim/init.lua<CR>", opts)
map("n", "<leader>d", ":bp <BAR> bd #<CR>", opts)
map("n", "[b", ":bprevious<CR>", opts)
map("n", "]b", ":bnext<CR>", opts)
map("n", "<C-j>", "10j", opts)
map("n", "<C-k>", "10k", opts)
map("n", "<C-s>", ":w<CR>", opts)

function _G.set_terminal_keymaps()
    local bufmap = vim.api.nvim_buf_set_keymap
    local opt = {
        noremap = true
    }
    bufmap(0, "t", "<esc>", "<C-\\><C-n>", opt);
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
