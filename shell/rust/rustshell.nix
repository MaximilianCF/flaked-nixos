{
  description = "Ambiente de desenvolvimento Rust";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          name = "rust-dev-shell";

          nativeBuildInputs = [
            pkgs.rustc
            pkgs.cargo
            pkgs.rust-analyzer
            pkgs.rustfmt
            pkgs.clippy
            pkgs.pkg-config
            pkgs.cmake
            pkgs.llvm
            pkgs.clang
            pkgs.libclang
            pkgs.openssl
            pkgs.openssl.dev
            pkgs.libudev-zero
            pkgs.libusb1
            pkgs.zlib
            pkgs.git
            pkgs.jq
          ];

          shellHook = ''
            export RUST_BACKTRACE=1
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
            echo "🦀 Ambiente Rust carregado com suporte a FFI e ROS 2."
          '';
        };
    };
}
