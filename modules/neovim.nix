{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    filetype.extension.gohtml = "gotmpl";

    extraFiles."after/queries/gotmpl/injections.scm".text = ''
      ; extends
      ((text) @injection.content
        (#set! injection.language "html")
        (#set! injection.combined))
    '';

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    opts = {
      mouse = "a";
      number = true;
      relativenumber = true;
      cursorline = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      scrolloff = 4;
      sidescrolloff = 8;
      ignorecase = true;
      smartcase = true;
      splitbelow = true;
      splitright = true;
      clipboard = "unnamedplus";
      termguicolors = true;
      undolevels = 10000;
      updatetime = 200;
      timeoutlen = 300;
      signcolumn = "yes";
      autowrite = true;
      confirm = true;
      autoread = true;
    };

    autoCmd = [
      # Reload files changed outside of nvim
      {
        event = [ "FocusGained" "BufEnter" "CursorHold" "CursorHoldI" ];
        pattern = [ "*" ];
        command = "if mode() != 'c' | checktime | endif";
      }
      # Notify when file changes
      {
        event = [ "FileChangedShellPost" ];
        pattern = [ "*" ];
        command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None";
      }
    ];

    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "storm";
        transparent = true;
      };
    };

    plugins = {
      neo-tree.enable = true;
      telescope.enable = true;
      bufferline.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      luasnip.enable = true;
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
        settings.indent.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          # Include all default grammars plus gotmpl for .gohtml files
          bash c css diff dockerfile go gomod gosum gotmpl
          html javascript json lua make markdown markdown_inline
          nix python query regex rust toml tsx typescript vim vimdoc yaml
        ];
      };
      indent-blankline.enable = true;
      toggleterm = {
        enable = true;
        settings.open_mapping = "[[<C-\\>]]";
      };
      web-devicons.enable = true;
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          denols.enable = true;
          gopls.enable = true;
          pyright.enable = true;
          tailwindcss.enable = true;
          taplo.enable = true;
        };
      };
    };

    keymaps = [
      # Window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }

      # Buffer navigation
      { mode = "n"; key = "<S-h>"; action = "<cmd>BufferLineCyclePrev<cr>"; options.desc = "Prev buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>BufferLineCycleNext<cr>"; options.desc = "Next buffer"; }

      # Resize windows
      { mode = "n"; key = "<C-Up>"; action = "<cmd>resize +2<cr>"; options.desc = "Increase window height"; }
      { mode = "n"; key = "<C-Down>"; action = "<cmd>resize -2<cr>"; options.desc = "Decrease window height"; }
      { mode = "n"; key = "<C-Left>"; action = "<cmd>vertical resize -2<cr>"; options.desc = "Decrease window width"; }
      { mode = "n"; key = "<C-Right>"; action = "<cmd>vertical resize +2<cr>"; options.desc = "Increase window width"; }

      # Telescope
      { mode = "n"; key = "<leader><space>"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>/"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Live grep"; }
      { mode = "n"; key = "<leader>,"; action = "<cmd>Telescope buffers<cr>"; options.desc = "Switch buffer"; }

      # File explorer
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Toggle file explorer"; }

      # New file / buffer delete
      { mode = "n"; key = "<leader>fn"; action = "<cmd>enew<cr>"; options.desc = "New file"; }
      { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<cr>"; options.desc = "Delete buffer"; }

      # Splits
      { mode = "n"; key = "<leader>-"; action = "<cmd>split<cr>"; options.desc = "Split below"; }
      { mode = "n"; key = "<leader>|"; action = "<cmd>vsplit<cr>"; options.desc = "Split right"; }
      { mode = "n"; key = "<leader>wd"; action = "<C-w>c"; options.desc = "Close window"; }

      # LSP
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<cr>"; options.desc = "Go to definition"; }
      { mode = "n"; key = "gr"; action = "<cmd>lua vim.lsp.buf.references()<cr>"; options.desc = "Go to references"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<cr>"; options.desc = "Hover docs"; }
      { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>"; options.desc = "Code action"; }
      { mode = "n"; key = "<leader>cr"; action = "<cmd>lua vim.lsp.buf.rename()<cr>"; options.desc = "Rename"; }
    ];
  };
}
