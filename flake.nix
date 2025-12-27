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
        patchedConfig = pkgs.runCommand "neovim-patched-config" {} ''
          mkdir -p $out
          cp -r ${self}/lua $out/
          sed 's/vim.g.auto_download = true/vim.g.auto_download = false/' \
            ${self}/init.lua > $out/init.lua
        '';
        nvim-tmux-navigation = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-tmux-navigation";
          src = inputs.nvim-tmux-navigation;
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
        ];
        optionalPlugins = with pkgs.vimPlugins; [
        ];
      in {
        options.programs.neovim-penultimum = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable neovim-penultimum config";
          };
          colorscheme = lib.mkOption {
            type = lib.types.string;
            default = "evergarden";
            # description = ""
          };

        };

        config.programs.neovim = {
          extraPackages = with pkgs; [
            wl-clipboard
            ripgrep
            fd

            nil
            tinymist
            bash-language-server
          ];
          plugins = startPlugins
            ++ (map (p: { plugin = p; optional = true; }) optionalPlugins);
        };

        config.xdg.configFile."nvim".source = patchedConfig;
      };
    };
}
