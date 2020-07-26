#! /usr/bin/env bash

set -euxo pipefail

function main() {
  local PATCHES_DIR
  PATCHES_DIR="$(realpath --canonicalize-existing --no-symlinks "$(dirname "${0}")/../../patches")"
  declare -r PATCHES_DIR

  local temp_dir
  temp_dir="$(mktemp -d)"

  # shellcheck disable=SC2064
  trap "rm -rf ${temp_dir}" "EXIT"

  cd "${temp_dir}"

  asp update kwin
  asp checkout kwin

  cd kwin

  local patch_name
  patch_name="pkgbuild"

  cp "${PATCHES_DIR}/arch/${patch_name}/${patch_name}.patch" .
  git apply "${patch_name}.patch"

  cd "repos/extra-x86_64"

  patch_name="highlight-window-no-partial-opacity"

  cp "${PATCHES_DIR}/kwin/${patch_name}/${patch_name}.patch" .

  PKGEXT=".pkg.tar" makepkg -sri
}

main
