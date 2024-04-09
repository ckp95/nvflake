{
  description = "My own Neovim flake!";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };
    telescope-recent-files-src = {
      url = "github:smartpde/telescope-recent-files";
      flake = false;
    };
  };

  outputs = { self, nixpkgs,
            # neovim,
            telescope-recent-files-src }:
    let
      overlayFlakeInputs = prev: final: {
        neovim = final.neovim-unwrapped;
        vimPlugins = final.vimPlugins // {
          telescope-recent-files = import ./packages/vimPlugins/telescopeRecentFiles.nix {
            src = telescope-recent-files-src;
            pkgs = prev;
          };
        };
      };
      overlayMyNeovim = prev: final: {
        myNeovim = import ./packages/my-neovim.nix { pkgs = final; };
      };
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlayFlakeInputs overlayMyNeovim ];
      };

    in {
      packages.x86_64-linux.default = pkgs.myNeovim;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${pkgs.myNeovim}/bin/nvim";
      };
    };
}
