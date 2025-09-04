{ pkgs, ... }:

{

  programs.ruff = {
    enable = true;
    package = pkgs.ruff;
    settings = {
      line-length = 100;
      per-file-ignores = {
        "__init__.py" = [ "F401" ];
      };
      lint = {
        select = [
          "E4"
          "E7"
          "E9"
          "F"
        ];
        ignore = [ ];
      };
    };
  };

}
