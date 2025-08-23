{ pkgs }:

with pkgs;
[
  #foxglove-cli
  g2o
  octaveFull
  octavePackages.statistics
  octavePackages.control
  octavePackages.signal
  octavePackages.optim
  octavePackages.linear-algebra
  octavePackages.financial
  octavePackages.io
  octavePackages.image
  octavePackages.data-smoothing

]
