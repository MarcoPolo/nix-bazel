{ system ? builtins.currentSystem, ... }@config:
let
  pkgs = import <nixpkgs> config;
  bazel3 = (import (builtins.fetchTarball
    "https://github.com/avdv/nixpkgs/archive/bazel_3.tar.gz") config).bazel;
in with pkgs;
pkgs.dockerTools.buildImage {
  name = "marcop010/nix-bazel";
  tag = "latest";
  contents = [ bash nix bazel3 ];

  config = {
    Cmd = [ "/bin/bash" ];
    WorkingDir = "/app";
  };
}
