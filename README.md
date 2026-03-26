# Neovim Penultimum
This is my personal Neovim configuration, and therefore I only care for it to work for me. \
There are two installation methods:
- Executing *install.sh* Bash script.
- Using Home Manager module:
  1. In inputs in *flake.nix* add:
  ```nix
  neovim-penultimum.url = "github:joo-was-already-taken/neovim-penultimum";
  ```
  2. Add the following to your Home Manager files:
  ```nix
  programs.neovim = {
    enable = true;
    package = inputs.neovim-penultimum.packages.${YOUR_SYSTEM}.neovim;
  };
  programs.neovim-penultimum.enable = true;
  ```
