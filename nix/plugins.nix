{ inputs, ... }:
{
  _module.args.plugins = pkgs: let
    nvim-tmux-navigation = (pkgs.vimUtils.buildVimPlugin {
      name = "nvim-tmux-navigation";
      src = inputs.nvim-tmux-navigation;
    }).overrideAttrs {
      pname = "nvim-tmux-navigation";
    };
    evergarden-colorscheme = (pkgs.vimUtils.buildVimPlugin {
      name = "evergarden";
      src = inputs.evergarden-colorscheme;
    }).overrideAttrs {
      pname = "evergarden";
      nvimSkipModules = [
        "minidoc"
        "evergarden.extras"
      ];
    };
    git-conflict-nvim = (pkgs.vimUtils.buildVimPlugin {
      name = "git-conflict-nvim";
      src = inputs.git-conflict-nvim;
    }).overrideAttrs {
      pname = "git-conflict-nvim";
    };
  in {
    start = with pkgs.vimPlugins; [
      lz-n
      plenary-nvim
      nvim-web-devicons
      nui-nvim
      hydra-nvim
      nvim-notify
      copilot-lualine
    ];
    opt = with pkgs.vimPlugins; [
      neo-tree-nvim
      lualine-nvim
      noice-nvim
      nvim-surround
      indent-blankline-nvim
      nvim-tmux-navigation
      telescope-nvim
      vim-obsession
      smart-splits-nvim
      blink-cmp
      mini-pairs
      nvim-lspconfig
      lspsaga-nvim
      undotree
      conform-nvim
      render-markdown-nvim
      markdown-preview-nvim
      no-neck-pain-nvim
      typst-preview-nvim
      copilot-lua
      fidget-nvim
      gitsigns-nvim
      git-conflict-nvim

      evergarden-colorscheme

      (nvim-treesitter.withPlugins (plugins: with plugins; [
        tree-sitter-nix
        tree-sitter-lua
        tree-sitter-bash
        tree-sitter-gitignore
        tree-sitter-python
        tree-sitter-markdown
        tree-sitter-markdown_inline
        tree-sitter-typst
        tree-sitter-latex
        tree-sitter-make
        tree-sitter-regex
        tree-sitter-toml
        tree-sitter-yaml
        tree-sitter-json
        tree-sitter-vim
        tree-sitter-vimdoc
        tree-sitter-rust
        tree-sitter-haskell
        tree-sitter-go
        tree-sitter-html
        tree-sitter-c
        tree-sitter-cpp
        tree-sitter-cmake
        tree-sitter-zig
        tree-sitter-javascript
        tree-sitter-css
      ]))
    ];
  };
}
