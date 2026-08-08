#!/usr/bin/env bash
set -euo pipefail

if (( $# > 1 )); then
  echo 'Invalid number of arguments, at most 1 expected' >&2
  exit 1
fi

install_method="${1:-link}"
install_config() {
  case "$install_method" in
    copy) cp -rv -- init.lua lua after "$DEST/";;
    link)
      ln -sfv -- "$(realpath init.lua)" "$DEST/init.lua"
      ln -sfnv -- "$(realpath lua)" "$DEST/lua"
      ln -sfnv -- "$(realpath after)" "$DEST/after"
      ;;
    *)
      echo "Invalid installation method specified, expected 'link' or 'copy'" >&2
      exit 1
      ;;
  esac
}

DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
mkdir -p -- "$DEST"

cd "$(dirname "${BASH_SOURCE[0]}")"
install_config

git clone --depth=1 https://github.com/savq/paq-nvim.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
