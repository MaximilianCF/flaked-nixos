#!/usr/bin/env bash
set -euo pipefail

# 🧠 Força execução a partir da raiz do projeto
cd "$(dirname "$0")/.."

TITLE="🧠 Nix Hub TUI"
PROMPT="👉 Escolha uma opção:"
OPTIONS=(
  "🔄 Atualizar sistema (nixos-upgrade)"
  "🧼 Limpeza segura (nix-gc-safe)"
  "📚 Ver opções declarativas (nixos-options-fzf)"
  "🧠 Comparar flake.lock (flake-diff)"
  "🛠 Listar DevShells disponíveis"
  "🧪 Entrar em um devShell declarativo"
  "💡 Ver versão do sistema"
  "🚪 Sair"
)

run_option() {
  case "$1" in
    "🔄 Atualizar sistema (nixos-upgrade)")
      nixos-upgrade
      ;;
    "🧼 Limpeza segura (nix-gc-safe)")
      nix-gc-safe
      ;;
    "📚 Ver opções declarativas (nixos-options-fzf)")
      nixos-options-fzf
      ;;
    "🧠 Comparar flake.lock (flake-diff)")
      flake-diff
      ;;
    "🛠 Listar DevShells disponíveis")
      devshell-list
      ;;
    "🧪 Entrar em um devShell declarativo")
      echo "🔍 Buscando devShells declarativos..."

      ALL_SHELLS=$(
        for path in . ./shell/*; do
          [ -f "$path/flake.nix" ] || continue
          nix flake show --json "$path" 2>/dev/null | jq -r --arg path "$path" '
            .devShells."x86_64-linux" | keys[]? | "\($path):\(.)"
          ' || true
        done
      )

      if [ -z "$ALL_SHELLS" ]; then
        echo "⚠️ Nenhum devShell encontrado."
        read -rp "Pressione Enter para voltar ao menu..."
        return
      fi

      SELECTED=$(printf "%s\n" "$ALL_SHELLS" | fzf --prompt="Escolha o devShell → " \
        --preview '
          FLAKE=$(echo {} | cut -d: -f1)
          SHELL=$(echo {} | cut -d: -f2)
          nix eval "$FLAKE"#devShells.x86_64-linux."$SHELL".packages --apply "toString" 2>/dev/null | fold -s
        ' \
        --preview-window=up:wrap --height=40% --border)

      if [ -n "$SELECTED" ]; then
        FLAKE_PATH=$(echo "$SELECTED" | cut -d: -f1)
        SHELL_NAME=$(echo "$SELECTED" | cut -d: -f2)
        echo "🧪 Entrando em: nix develop $FLAKE_PATH#$SHELL_NAME"
        nix develop "$FLAKE_PATH#$SHELL_NAME"
      fi
      ;;
    "💡 Ver versão do sistema")
      echo -e "\n🔍 NixOS: $(nixos-version)"
      echo "🔧 Flake: $(nix eval .#nixosConfigurations.nixos.config.system.nixos.version --raw 2>/dev/null || echo N/A)"
      echo "🧩 Kernel: $(uname -r)"
      read -rp $'\nPressione Enter para voltar ao menu...'
      ;;
    "🚪 Sair")
      echo "👋 Valeu, Max!"
      exit 0
      ;;
  esac
}

while true; do
  SELECTED=$(printf "%s\n" "${OPTIONS[@]}" | fzf --prompt="$PROMPT " --header="$TITLE" --height=40% --border)
  [ -z "$SELECTED" ] && break
  clear
  run_option "$SELECTED"
  echo -e "\n✅ Comando finalizado. Voltando ao menu...\n"
  sleep 1
done
