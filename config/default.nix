{  }:
  lib.concatLines (
    builtins.map (file: "source ${./${file}}")
      (builtins.attrNames (builtins.readDir ./vim))
  );
