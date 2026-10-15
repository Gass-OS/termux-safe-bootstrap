#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

DEFAULT_PACKAGES=(git curl wget nano openssh python file)
DRY_RUN=0
CUSTOM_PACKAGES=""

usage() {
  cat <<'EOF'
Termux Safe Bootstrap

Usage:
  bash bootstrap.sh [--dry-run] [--packages "git python clang"] [--help]

Options:
  --dry-run          Print planned actions without changing anything
  --packages "..."   Override the default package list (space-separated)
  --help             Show this help
EOF
}

while (($#)); do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --packages)
      [[ $# -ge 2 ]] || { echo "Missing value for --packages" >&2; exit 2; }
      CUSTOM_PACKAGES="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -z "${PREFIX:-}" || ! "$PREFIX" == *"/com.termux/"* && ! "$PREFIX" == *"/usr" ]]; then
  echo "Warning: this does not look like a standard Termux environment (PREFIX=${PREFIX:-unset})."
  echo "Continue only if you understand the package manager being used."
fi

if ! command -v pkg >/dev/null 2>&1; then
  echo "Error: 'pkg' was not found. Run this script inside Termux." >&2
  exit 1
fi

if [[ -n "$CUSTOM_PACKAGES" ]]; then
  read -r -a PACKAGES <<< "$CUSTOM_PACKAGES"
else
  PACKAGES=("${DEFAULT_PACKAGES[@]}")
fi

if ((${#PACKAGES[@]} == 0)); then
  echo "No packages selected; nothing to do."
  exit 0
fi

for package in "${PACKAGES[@]}"; do
  if [[ ! "$package" =~ ^[a-zA-Z0-9+._-]+$ ]]; then
    echo "Invalid package name: $package" >&2
    exit 2
  fi
done

printf 'Packages selected: %s\n' "${PACKAGES[*]}"
if ((DRY_RUN)); then
  printf 'DRY RUN: pkg install %q\n' "${PACKAGES[*]}"
  echo "No changes made."
  exit 0
fi

read -r -p "Install these packages using Termux pkg? [y/N] " answer
case "$answer" in
  y|Y|yes|YES) exec pkg install "${PACKAGES[@]}" ;;
  *) echo "Cancelled. No packages installed."; exit 0 ;;
esac
