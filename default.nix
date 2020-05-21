{ system ? builtins.currentSystem, ... }@config:
let
  pkgs = import <nixpkgs> config;
  bazel3 = (import (builtins.fetchTarball
    "https://github.com/avdv/nixpkgs/archive/bazel_3.tar.gz") config).bazel;
  nixos = pkgs.dockerTools.pullImage {
    imageName = "nixos/nix";
    finalImageTag = "latest";
    imageDigest = "sha256:399eb8b7faf90fd010674da906366bbb2391f04577c0365a4d7d9300678e84c1";
    sha256 = "sha256:08cnjwl5jh35pngbq9rkvj5mkk7d3m3k0hfxhr6v4i63brm8n2s3";
  };
in
pkgs.dockerTools.buildImage {
  name = "marcop010/nix-bazel";
  tag = "latest";
  fromImage = nixos;
  contents = with pkgs; [ bazel3 ];

  config = {
    Cmd = [ "/bin/sh" ];
    WorkingDir = "/app";
    Env = [
      "ENV=/etc/profile"
      "USER=root"
      "PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin"
      "GIT_SSL_CAINFO=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt"
      "NIX_PATH=/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
