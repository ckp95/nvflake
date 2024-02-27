{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-recent-files
    nvim-lspconfig
    catppuccin-nvim
  ];
  runtimeDeps = with pkgs; [
    lazygit
    # packages with results in /lib/node_modules/.bin must come at the end
    nodePackages.pyright
    nodePackages.typescript
    nodePackages.typescript-language-server
  ];
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = runtimeDeps;
    # see: https://ertt.ca/blog/2022/01-12-nix-symlinkJoin-nodePackages/
    postBuild = ''
      for f in $out/lib/node_modules/.bin/*; do
        path="$(readlink --canonicalize-missing "$f")"
        ln -s "$path" "$out/bin/$(basename $f)"
      done
    '';
  };
  myNeovimUnwrapped = pkgs.wrapNeovim pkgs.neovim {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };
in pkgs.writeShellApplication {
  name = "nvim";
  # these get added to the PATH environmental variable when neovim is run:
  runtimeInputs = [ neovimRuntimeDependencies ];
  text = ''
    ${myNeovimUnwrapped}/bin/nvim "$@"
  '';
}
