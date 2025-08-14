{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Max";
    userEmail = "maximiliancf.dev@icloud.com";
    package = pkgs.git;
    lfs = {
      enable = true;
    };
    delta = {
      enable = true;
      package = pkgs.delta;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };
}
