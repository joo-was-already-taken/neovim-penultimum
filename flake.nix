{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      imports = [
        ./nix/plugins.nix
        ./nix/home-manager.nix
      ];
      perSystem = { pkgs, system, ... }: {
        packages.neovim = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            tree-sitter
            lua-language-server
            stylua
            nodejs
            stdenv
            ripgrep
            fd
            cachix
          ];
        };
      };
    });
}
