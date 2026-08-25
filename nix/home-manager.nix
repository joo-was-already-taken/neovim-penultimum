{ inputs, plugins, ... }:
{
  flake.homeModules = rec {
    default = neovim-penultimum;
    neovim-penultimum = { config, lib, pkgs, ... }: let
      inherit (lib) types;
      cfg = config.neovim-penultimum;
      pkgs' = import cfg.pkgs.path {
        inherit (cfg.pkgs) system overlays;
        config = (cfg.pkgs.config or {}) // {
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [ "copilot-language-server" ] ||
            (cfg.pkgs.config ? allowUnfreePredicate && cfg.pkgs.config.allowUnfreePredicate pkg);
        };
      };
      patchedConfig = pkgs'.runCommand "neovim-config-patched" {} ''
        mkdir -p $out
        cp -r ${../after} $out/after
        cp -r ${../lua} $out/lua
        sed \
          -e 's/vim.g.allow_downloads =.*/vim.g.allow_downloads = false/' \
          -e 's/vim.g.default_colorscheme =.*/vim.g.default_colorscheme = "${cfg.colorscheme}"/' \
          ${../init.lua} > $out/init.lua
      '';
    in {
      options.neovim-penultimum = {
        enable = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Enable neovim-penultimum config";
        };
        colorscheme = lib.mkOption {
          type = types.str;
          default = "evergarden";
          description = "Colorscheme to set via `vim.cmd.colorscheme`";
        };
        pkgs = lib.mkOption {
          type = types.pkgs;
          default = pkgs;
          description = "Package set to use for Neovim and its plugins";
        };
      };

      config = lib.mkIf cfg.enable {
        programs.neovim = {
          enable = true;
          package = pkgs'.neovim-unwrapped;
          withRuby = false;
          withPython3 = false;
          extraPackages = with pkgs'; [
            ripgrep
            fd
            curl
            nodejs-slim_22
          ];
          plugins = (plugins pkgs').start
            ++ (map (p: { plugin = p; optional = true; }) (plugins pkgs').opt);
        };
        xdg.configFile."nvim".source = patchedConfig;
        home.packages = [
          inputs.herdr-navigator.packages.${pkgs'.stdenv.hostPlatform.system}.herdr-navigator
        ];
      };
    };
  };
}
