#!/bin/bash
set -euo pipefail

# Amazing PsyCoder — validated, staged cross-platform installer

MODE="install"
SCOPE="user"
PROJECT_DIR="$(pwd)"
REQUESTED=""

usage() {
    cat <<'EOF'
Usage:
  ./install.sh [--check] claude|codex|hermes|openclaw
  ./install.sh [--check] [--scope project] [--project-dir PATH] claude|codex|openclaw
  ./install.sh [--check] /absolute/path/to/skills

Examples:
  ./install.sh claude
  ./install.sh codex
  ./install.sh hermes
  ./install.sh openclaw
  ./install.sh --scope project --project-dir /path/to/repo claude
  ./install.sh --check codex

Project scope is defined for Claude Code, Codex, and an OpenClaw agent
workspace. For a custom Hermes directory, pass its absolute skills path.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)
            MODE="check"
            shift
            ;;
        --scope)
            [[ $# -ge 2 ]] || { echo "--scope requires user or project"; exit 1; }
            SCOPE="$2"
            shift 2
            ;;
        --project-dir)
            [[ $# -ge 2 ]] || { echo "--project-dir requires a path"; exit 1; }
            PROJECT_DIR="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --*)
            echo "Unknown argument: $1"
            usage
            exit 1
            ;;
        *)
            [[ -z "$REQUESTED" ]] || { echo "Specify only one platform or install path"; exit 1; }
            REQUESTED="$1"
            shift
            ;;
    esac
done

[[ "$SCOPE" == "user" || "$SCOPE" == "project" ]] || {
    echo "Unknown scope: $SCOPE (use user or project)"
    exit 1
}

detect_platform() {
    local requested="${1:-}"
    local candidates=()

    # Explicit platform/path always wins over auto-detection.
    if [[ -n "$requested" ]]; then
        echo "$requested"
        return
    fi

    [[ -n "${CLAUDE_CODE:-}" ]] && candidates+=("claude")
    command -v codex &>/dev/null && candidates+=("codex")
    command -v hermes &>/dev/null && candidates+=("hermes")
    [[ -n "${HOME:-}" && -d "${HOME}/.openclaw" ]] && candidates+=("openclaw")

    if [[ ${#candidates[@]} -eq 1 ]]; then
        echo "${candidates[0]}"
    elif [[ ${#candidates[@]} -gt 1 ]]; then
        echo "ambiguous:${candidates[*]}"
    fi
}

PLATFORM=$(detect_platform "$REQUESTED")

if [[ "$PLATFORM" == ambiguous:* ]]; then
    echo "Multiple hosts detected: ${PLATFORM#ambiguous:}"
    echo "Specify claude, codex, hermes, or openclaw explicitly."
    exit 1
fi

if [[ -z "$PLATFORM" ]]; then
    echo "Could not detect a platform; specify one:"
    echo "  ./install.sh claude"
    echo "  ./install.sh codex"
    echo "  ./install.sh hermes"
    echo "  ./install.sh openclaw"
    echo "  Or specify a path: ./install.sh /path/to/skills"
    exit 1
fi

# Use an explicit path directly.
if [[ "$PLATFORM" == /* ]]; then
    SKILLS_DIR="$PLATFORM"
else
    if [[ -z "${HOME:-}" ]]; then
        echo "Cannot determine the install directory: HOME is unset. Pass an absolute path."
        exit 1
    fi
    if [[ "$SCOPE" == "project" ]]; then
        PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
        case "$PLATFORM" in
            claude) SKILLS_DIR="$PROJECT_DIR/.claude/skills" ;;
            codex|openclaw) SKILLS_DIR="$PROJECT_DIR/.agents/skills" ;;
            *) echo "$PLATFORM does not support --scope project; pass an absolute install path"; exit 1 ;;
        esac
    else
        case "$PLATFORM" in
            claude)   SKILLS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills" ;;
            codex)    SKILLS_DIR="$HOME/.agents/skills" ;;
            hermes)   SKILLS_DIR="$HOME/.hermes/skills" ;;
            openclaw) SKILLS_DIR="$HOME/.openclaw/skills" ;;
            *)        echo "Unknown platform: $PLATFORM"; exit 1 ;;
        esac
    fi
fi

if [[ "$MODE" == "install" ]]; then
    mkdir -p "$SKILLS_DIR"
elif [[ ! -d "$SKILLS_DIR" ]]; then
    echo "Not installed: directory does not exist: $SKILLS_DIR"
    exit 1
fi

echo "Platform: $PLATFORM"
echo "Scope: $SCOPE"
echo "Directory: $SKILLS_DIR"
echo ""

SKILL_ROOT="$(cd "$(dirname "$0")" && pwd)"
VALIDATOR_PYTHON="${PYTHON_BIN:-python3}"

if [[ "$MODE" == "install" ]]; then
    echo "Validating source skills..."
    "$VALIDATOR_PYTHON" "$SKILL_ROOT/scripts/validate_skills.py" --portable
    echo ""
fi

TX_DIR=""
TX_COMMITTED=()

rollback_transaction() {
    local index name dest backup
    set +e
    for ((index=${#TX_COMMITTED[@]}-1; index>=0; index--)); do
        name="${TX_COMMITTED[$index]}"
        dest="$SKILLS_DIR/$name"
        backup="$TX_DIR/backup/$name"
        rm -rf "$dest"
        if [[ -e "$backup" || -L "$backup" ]]; then
            mv "$backup" "$dest"
        fi
    done
    [[ -n "$TX_DIR" ]] && rm -rf "$TX_DIR"
    TX_DIR=""
    TX_COMMITTED=()
    set -e
}

trap 'status=$?; if [[ -n "$TX_DIR" ]]; then echo "Installation interrupted; rolling back all skills."; rollback_transaction; fi; exit "$status"' ERR
trap 'if [[ -n "$TX_DIR" ]]; then echo "Installation interrupted; rolling back all skills."; rollback_transaction; fi; exit 130' INT TERM HUP

install_all() {
    local pairs=(
        "$SKILL_ROOT|amazing-psycoder"
        "$SKILL_ROOT/psy-exp-designer|psy-exp-designer"
        "$SKILL_ROOT/psy-exp-coder|psy-exp-coder"
        "$SKILL_ROOT/psy-exp-reviewer|psy-exp-reviewer"
        "$SKILL_ROOT/psy-ana-designer|psy-ana-designer"
        "$SKILL_ROOT/psy-ana-coder|psy-ana-coder"
        "$SKILL_ROOT/psy-ana-reviewer|psy-ana-reviewer"
    )
    local pair src name dest backup

    TX_DIR=$(mktemp -d "$SKILLS_DIR/.amazing-psycoder.transaction.XXXXXX")
    mkdir -p "$TX_DIR/stage" "$TX_DIR/backup"

    # Copy every source before changing any installed skill.
    for pair in "${pairs[@]}"; do
        src="${pair%%|*}"
        name="${pair#*|}"
        mkdir "$TX_DIR/stage/$name"
        cp -R "$src"/. "$TX_DIR/stage/$name"/
    done

    # Same-filesystem moves make each replacement atomic; backups remain until all seven commit.
    for pair in "${pairs[@]}"; do
        name="${pair#*|}"
        dest="$SKILLS_DIR/$name"
        backup="$TX_DIR/backup/$name"
        if [[ -e "$dest" || -L "$dest" ]]; then
            mv "$dest" "$backup"
        fi
        if ! mv "$TX_DIR/stage/$name" "$dest"; then
            if [[ -e "$backup" || -L "$backup" ]]; then
                mv "$backup" "$dest"
            fi
            echo "  ✗ Failed to install ${name}; rolling back all skills"
            rollback_transaction
            return 1
        fi
        TX_COMMITTED+=("$name")
        echo "  ✓ $name"
    done

    rm -rf "$TX_DIR"
    TX_DIR=""
    TX_COMMITTED=()
}

check_dir() {
    local src="$1"
    local name="$2"
    local dest="$SKILLS_DIR/$name"
    if [[ ! -d "$dest" ]]; then
        echo "  ✗ $name is not installed"
        return 1
    fi
    if diff -qr "$src" "$dest" >/dev/null; then
        echo "  ✓ $name matches the source workspace"
    else
        echo "  ✗ $name differs from the source or is outdated"
        return 1
    fi
}

run_for_all() {
    local action="$1"
    local status=0
    local pairs=(
        "$SKILL_ROOT|amazing-psycoder"
        "$SKILL_ROOT/psy-exp-designer|psy-exp-designer"
        "$SKILL_ROOT/psy-exp-coder|psy-exp-coder"
        "$SKILL_ROOT/psy-exp-reviewer|psy-exp-reviewer"
        "$SKILL_ROOT/psy-ana-designer|psy-ana-designer"
        "$SKILL_ROOT/psy-ana-coder|psy-ana-coder"
        "$SKILL_ROOT/psy-ana-reviewer|psy-ana-reviewer"
    )
    local pair src name
    for pair in "${pairs[@]}"; do
        src="${pair%%|*}"
        name="${pair#*|}"
        if ! "$action" "$src" "$name"; then
            status=1
            [[ "$action" == "check_dir" ]] || return 1
        fi
    done
    return "$status"
}

if [[ "$MODE" == "check" ]]; then
    echo "Checking installed skills against the source workspace..."
    if run_for_all check_dir; then
        echo "All installed skills match the source workspace."
        exit 0
    fi
    echo "Installation differs; rerun the install command to synchronize."
    exit 1
fi

echo "Installing Amazing PsyCoder..."

install_all

echo ""
echo "Done. Invoke it according to your platform:"
echo "  Claude Code: /amazing-psycoder"
echo "  Codex:       \$amazing-psycoder"
echo "  Hermes:      /amazing-psycoder (or automatic matching)"
echo "  OpenClaw:    /amazing-psycoder (or automatic matching)"
echo ""
echo "Experiment pipeline: psy-exp-designer → psy-exp-coder → psy-exp-reviewer"
echo "Analysis pipeline: psy-ana-designer → psy-ana-coder → psy-ana-reviewer"
