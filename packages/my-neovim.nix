{ pkgs }:
let
  customRc = import ../config;
in pkgs.wrapNeovim pkgs.neovim {
  configure = {
    inherit customRc;
  };
}
