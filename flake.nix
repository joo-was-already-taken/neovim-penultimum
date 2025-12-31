{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-tmux-navigation = {
      url = "github:alexghergh/nvim-tmux-navigation";
      flake = false;
    };
    evergarden-colorscheme = {
      url = "github:everviolet/nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          inputs.neovim-nightly.overlays.default
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            neovim
            tree-sitter
            lua-language-server
            stylua
            nodejs
            stdenv
            ripgrep
            fd
          ];
        };

        packages.neovim = pkgs.neovim;
      }
    ) // rec {
      homeManagerModules.default = homeManagerModules.neovim-penultimum;
      homeManagerModules.neovim-penultimum = { config, lib, pkgs, ... }: let
        cfg = config.programs.neovim-penultimum;
        patchedConfig = pkgs.runCommand "neovim-patched-config" {} ''
          mkdir -p $out
          cp -r ${self}/lua $out/
          sed \
            -e 's/vim.g.allow_downloads =.*/vim.g.allow_downloads = false/' \
            -e 's/vim.g.default_colorscheme =.*/vim.g.default_colorscheme = "${cfg.colorscheme}"/' \
            ${self}/init.lua > $out/init.lua
        '';
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

        startPlugins = with pkgs.vimPlugins; [
          lz-n
          plenary-nvim
          nvim-web-devicons
          nui-nvim
          hydra-nvim
          nvim-notify
        ];
        optPlugins = with pkgs.vimPlugins; [
          neo-tree-nvim
          lualine-nvim
          noice-nvim
          nvim-surround
          indent-blankline-nvim-lua
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
      in {
        options.programs.neovim-penultimum = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable neovim-penultimum config";
          };
          colorscheme = lib.mkOption {
            type = lib.types.str;
            default = "evergarden";
            description = "Colorscheme to set via `vim.cmd.colorscheme`";
          };
        };

        config.programs.neovim = {
          extraPackages = with pkgs; [
            wl-clipboard
            ripgrep
            fd
          ];
          plugins = startPlugins
            ++ (map (p: { plugin = p; optional = true; }) optPlugins);
        };

        config.xdg.configFile."nvim".source = patchedConfig;
      };
    };
}
