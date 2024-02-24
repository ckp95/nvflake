{ pkgs }:
let customRc = import ../config { inherit pkgs; };
in pkgs.wrapNeovim pkgs.neovim { configure = { inherit customRc; }; }
