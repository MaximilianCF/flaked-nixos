{
  description = "DevShell Rust reprodutível (stable) com rust-analyzer, clippy, sccache, mold/lld";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Overlay do Rust (oxalica) – facilita pegar toolchains pinadas por canal
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      rust-overlay,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          # pkgs com overlay do Rust habilitado
          pkgsRust = import nixpkgs {
            inherit system;
            overlays = [
              (import rust-overlay)
            ];
          };

          # Toolchain Rust estável com componentes úteis
          rustToolchain = pkgsRust.rust-bin.stable.latest.default.override {
            extensions = [
              "rust-src"
              "rustfmt"
              "clippy"
            ]; # rust-analyzer vem fora
          };

          # Se quiser targets extras (ex.: WASM), use:
          # rustToolchain = pkgsRust.rust-bin.stable.latest.default.override {
          #   extensions = [ "rust-src" "rustfmt" "clippy" ];
          #   targets = [ "wasm32-unknown-unknown" ];
          # };

          # Utilitários cargo comuns (adicione/retire à vontade)
          cargoTools = with pkgsRust; [
            cargo-edit
            cargo-watch
            cargo-nextest
            cargo-audit
            cargo-deny
            # cargo-udeps # (geralmente pede nightly; ative se necessário)
          ];

          # Dependências nativas frequentes (openssl, sqlite etc.)
          nativeLibs = with pkgs; [
            pkg-config
            openssl
            sqlite
            zlib
          ];

          # Linkers e aceleração de compilação
          linkers = with pkgs; [
            mold
            lld
            sccache
          ];
        in
        {
          devShells = {
            # 'default' ativa com `nix develop`
            default = pkgs.mkShell {
              name = "rust-devshell";
              nativeBuildInputs = [
                rustToolchain
                pkgs.rust-analyzer
              ]
              ++ cargoTools
              ++ nativeLibs
              ++ linkers;

              # Variáveis/conveniências para builds rápidos
              shellHook = ''
                export RUST_BACKTRACE=1
                export RUST_LOG=info
                # Reutiliza artefatos (útil em monorepo)
                export CARGO_TARGET_DIR=${toString ./.}/target

                # sccache: acelera compilações (coloque seu cache onde preferir)
                export SCCACHE_DIR="$HOME/.cache/sccache"
                export RUSTC_WRAPPER=$(command -v sccache || true)

                # Usa mold se presente (fallback para lld)
                if command -v mold >/dev/null; then
                  export RUSTFLAGS="-C link-arg=-fuse-ld=mold ${"RUSTFLAGS:-"}"
                elif command -v ld.lld >/dev/null; then
                  export RUSTFLAGS="-C link-arg=-fuse-ld=lld ${"RUSTFLAGS:-"}"
                fi

                echo "🦀 $DEVSHELL_NAME ativo | $(rustc -V) | $(cargo -V)"
                echo "🦀 Rust devshell pronto (stable). Dicas:"
                echo "  - cargo check / build / test"
                echo "  - cargo clippy -- -D warnings"
                echo "  - cargo fmt"
                echo "  - rust-analyzer já disponível para seu editor"

              '';
            };

            # opcional: um shell nightly para udeps, experimentos, etc.
            nightly = pkgs.mkShell {
              name = "rust-devshell-nightly";
              nativeBuildInputs =
                let
                  nightly = pkgsRust.rust-bin.nightly.latest.default.override {
                    extensions = [
                      "rust-src"
                      "rustfmt"
                      "clippy"
                    ];
                  };
                in
                [
                  nightly
                  pkgs.rust-analyzer
                ]
                ++ cargoTools
                ++ nativeLibs
                ++ linkers;

              shellHook = ''
                export RUST_BACKTRACE=1
                export CARGO_TARGET_DIR=${toString ./.}/target-nightly
                export SCCACHE_DIR="$HOME/.cache/sccache"
                export RUSTC_WRAPPER=$(command -v sccache || true)
                export DEVSHELL_NAME="rust-devshell-stable"
                if command -v mold >/dev/null; then
                  export RUSTFLAGS="-C link-arg=-fuse-ld=mold ${"RUSTFLAGS:-"}"
                elif command -v ld.lld >/dev/null; then
                  export RUSTFLAGS="-C link-arg=-fuse-ld=lld ${"RUSTFLAGS:-"}"
                fi
                echo "🦀 Rust nightly devshell pronto."
                echo "🦀 $DEVSHELL_NAME ativo | $(rustc -V) | $(cargo -V)"
              '';
            };
          };
        };
    };
}
