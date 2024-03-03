{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = with pkgs.vimPlugins; [
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
  ] ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [
    ada
    awk
    bash
    c
    cpp
    css
    csv
    diff
    dockerfile
    doxygen
    git_config
    gitcommit
    gitignore
    go
    haskell
    ini
    java
    javascript
    jq
    json
    json5
    latex
    lua
    make
    markdown
    markdown_inline
    nix
    ocaml
    prql
    python
    r
    regex
    requirements
    rst
    rust
    scss
    sql
    ssh_config
    sxhkdrc
    toml
    tsv
    typescript
    vimdoc
    xml
    yaml
    zig
  ]);
  runtimeDeps = with pkgs; [
    lua-language-server
    nil
    rust-analyzer
    ripgrep
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
