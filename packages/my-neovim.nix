{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = import ../plugins.nix { inherit pkgs; };
  runtimeDeps = import ../runtimeDeps.nix { inherit pkgs; };
  # https://ertt.ca/blog/2022/01-12-nix-symlinkJoin-nodePackages/
  neovimRuntimeDependencies1 = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies1";
    paths = runtimeDeps.deps1;
  };
  neovimRuntimeDependencies2 = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies2";
    paths = runtimeDeps.deps2;
  };
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };
in
  pkgs.writeShellApplication {
    name = "nvim";
    # these get added to the PATH environmental variable when neovim is run:
    runtimeInputs = [ neovimRuntimeDependencies2 neovimRuntimeDependencies1 ];
    text = ''
      ${myNeovimUnwrapped}/bin/nvim "$@"
    '';
  }
