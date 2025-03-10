{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  treesitter_plugins = import ./treesitter-list.nix { inherit pkgs; };
  plugins = treesitter_plugins ++ (with pkgs.vimPlugins; [
    which-key-nvim
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-recent-files
    nvim-lspconfig
    catppuccin-nvim
    indent-blankline-nvim
    nvim-treesitter
    nvim-cmp
    cmp-nvim-lsp
    luasnip
    cmp_luasnip
    comment-nvim
  ]);
  runtimeDeps = with pkgs; [
    ripgrep
    lua-language-server
    nil
    rust-analyzer
    gopls
    # packages with results in /lib/node_modules/.bin must come at the end
    nodePackages.bash-language-server
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
