# Neovim Penultimum
This is my personal Neovim configuration, and therefore I only care for it to work for me. \
There are two installation methods:
- Executing *install.sh* Bash script.
- Using Home Manager module:
  1. In inputs in *flake.nix* add:
  ```nix
  neovim-penultimum.url = "github:joo-was-already-taken/neovim-penultimum";
  ```
  2. Add this to your Home Manager imports:
  ```nix
  inputs.neovim-penultimum.homeModules.default
  ```
  3. And in your Home Manager files add:
  ```nix
  neovim-penultimum.enable = true;
  programs.neovim.extraPackages [ pkgs.wl-clipboard ]; # or whatever clipboard you use
  ```
