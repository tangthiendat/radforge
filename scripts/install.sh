#!/bin/sh
set -eu

PROVIDER_ARG="all"
HOME_ROOT="${HOME:-}"
DRY_RUN=0
OVERWRITE_INSTRUCTIONS=0
IGNORE_INSTRUCTIONS=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        --provider)
            PROVIDER_ARG="$2"
            shift 2
            ;;
        --home-root)
            HOME_ROOT="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --overwrite-instructions)
            OVERWRITE_INSTRUCTIONS=1
            shift
            ;;
        --ignore-instructions)
            IGNORE_INSTRUCTIONS=1
            shift
            ;;
        *)
            printf 'Unknown argument: %s\n' "$1" >&2
            exit 1
            ;;
    esac
done

if [ -z "$HOME_ROOT" ]; then
    printf 'Unable to resolve user home directory.\n' >&2
    exit 1
fi

REPO_ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
PROVIDERS_ROOT="$REPO_ROOT/providers"
SKILLS_SOURCE_ROOT="$REPO_ROOT/skills"
GLOBAL_INSTRUCTIONS_SOURCE="$REPO_ROOT/global/AGENTS.md"
STATE_ROOT="$HOME_ROOT/.radforge"
PROVIDER_STATE_ROOT="$STATE_ROOT/providers"

bootstrap_install() {
    archive_url="${RADFORGE_ARCHIVE_URL:-https://github.com/tangthiendat/radforge/archive/refs/heads/main.tar.gz}"
    temp_root=$(mktemp -d 2>/dev/null || mktemp -d -t radforge)

    cleanup() {
        rm -rf "$temp_root"
    }

    trap cleanup EXIT INT TERM

    curl -fsSL "$archive_url" | tar -xz -C "$temp_root"

    extracted_root=""
    for candidate in "$temp_root"/*; do
        [ -d "$candidate" ] || continue
        extracted_root="$candidate"
        break
    done

    if [ -z "$extracted_root" ]; then
        printf 'Unable to locate extracted Radforge archive.\n' >&2
        exit 1
    fi

    script_path="$extracted_root/scripts/install.sh"
    if [ ! -f "$script_path" ]; then
        printf 'Unable to locate installer inside extracted Radforge archive.\n' >&2
        exit 1
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        if [ "$OVERWRITE_INSTRUCTIONS" -eq 1 ]; then
            if [ "$IGNORE_INSTRUCTIONS" -eq 1 ]; then
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --dry-run --overwrite-instructions --ignore-instructions
            else
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --dry-run --overwrite-instructions
            fi
        else
            if [ "$IGNORE_INSTRUCTIONS" -eq 1 ]; then
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --dry-run --ignore-instructions
            else
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --dry-run
            fi
        fi
    else
        if [ "$OVERWRITE_INSTRUCTIONS" -eq 1 ]; then
            if [ "$IGNORE_INSTRUCTIONS" -eq 1 ]; then
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --overwrite-instructions --ignore-instructions
            else
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --overwrite-instructions
            fi
        else
            if [ "$IGNORE_INSTRUCTIONS" -eq 1 ]; then
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT" --ignore-instructions
            else
                sh "$script_path" --provider "$PROVIDER_ARG" --home-root "$HOME_ROOT"
            fi
        fi
    fi
}

if [ ! -d "$PROVIDERS_ROOT" ] || [ ! -d "$SKILLS_SOURCE_ROOT" ] || [ ! -f "$GLOBAL_INSTRUCTIONS_SOURCE" ]; then
    bootstrap_install
    exit 0
fi

log() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] %s\n' "$1"
    else
        printf '[radforge] %s\n' "$1"
    fi
}

log_stderr() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] %s\n' "$1" >&2
    else
        printf '[radforge] %s\n' "$1" >&2
    fi
}

utc_now() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

ensure_dir() {
    if [ "$DRY_RUN" -eq 1 ]; then
        log "Would create directory '$1'."
        return
    fi

    mkdir -p "$1"
}

write_file() {
    path=$1
    parent=$(dirname "$path")
    ensure_dir "$parent"

    if [ "$DRY_RUN" -eq 1 ]; then
        log "Would write file '$path'."
        return
    fi

    tmp=$(mktemp)
    cat > "$tmp"
    mv "$tmp" "$path"
}

remove_path_if_exists() {
    if [ ! -e "$1" ]; then
        return
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        log "Would remove '$1'."
        return
    fi

    rm -rf "$1"
}

list_available_providers() {
    for dir in "$PROVIDERS_ROOT"/*; do
        [ -d "$dir" ] || continue
        basename "$dir"
    done | sort
}

is_supported_provider() {
    candidate=$1
    for provider_id in $(list_available_providers); do
        if [ "$provider_id" = "$candidate" ]; then
            return 0
        fi
    done

    return 1
}

manifest_value() {
    key=$1
    file=$2
    sed -n "s/^[[:space:]]*\"$key\":[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$file" | head -n 1
}

provider_display_names() {
    first=1
    for provider_id in "$@"; do
        manifest_path="$PROVIDERS_ROOT/$provider_id/manifest.json"
        display_name=$(manifest_value displayName "$manifest_path")
        if [ "$first" -eq 0 ]; then
            printf ', '
        fi
        printf '%s' "$display_name"
        first=0
    done
    printf '\n'
}

join_home_relative_path() {
    relative=$1
    relative=$(printf '%s' "$relative" | sed 's#\\#/#g')
    printf '%s/%s\n' "$HOME_ROOT" "$relative" | sed 's#//*#/#g'
}

state_value() {
    key=$1
    file=$2
    sed -n "s/^$key=//p" "$file" | head -n 1
}

strip_legacy_managed_block() {
    file_path=$1
    tmp=$(mktemp)
    awk '
        BEGIN { inside = 0 }
        $0 == "<!-- RADFORGE:BEGIN -->" { inside = 1; next }
        $0 == "<!-- RADFORGE:END -->" { inside = 0; next }
        !inside { print }
    ' "$file_path" > "$tmp"

    printf '%s\n' "$tmp"
}

remove_legacy_hint_from_state() {
    state_path=$1
    [ -f "$state_path" ] || return

    instructions_file=$(state_value instructions_file "$state_path")
    [ -n "$instructions_file" ] || return
    [ -f "$instructions_file" ] || return

    instructions_mode=$(state_value instructions_mode "$state_path")
    [ -n "$instructions_mode" ] || instructions_mode="legacy_block"
    [ "$instructions_mode" = "legacy_block" ] || return

    instructions_file_created=$(state_value instructions_file_created "$state_path")
    stripped_file=$(strip_legacy_managed_block "$instructions_file")

    if [ ! -s "$stripped_file" ] && [ "$instructions_file_created" = "1" ]; then
        remove_path_if_exists "$instructions_file"
    else
        cat "$stripped_file" | write_file "$instructions_file"
    fi

    rm -f "$stripped_file"
}

copy_skill_library() {
    destination_root=$1
    ensure_dir "$destination_root"

    installed_paths=""
    for skill_dir in "$SKILLS_SOURCE_ROOT"/*; do
        [ -d "$skill_dir" ] || continue
        [ -f "$skill_dir/SKILL.md" ] || continue
        skill_name=$(basename "$skill_dir")
        destination="$destination_root/$skill_name"
        remove_path_if_exists "$destination"

        if [ "$DRY_RUN" -eq 1 ]; then
            log "Would copy skill '$skill_dir' to '$destination'."
        else
            cp -R "$skill_dir" "$destination"
        fi

        if [ -z "$installed_paths" ]; then
            installed_paths=$destination
        else
            installed_paths="$installed_paths|$destination"
        fi
    done

    printf '%s\n' "$installed_paths"
}

is_interactive() {
    [ -t 0 ] && return 0
    [ -r /dev/tty ]
}

confirm_instructions_overwrite() {
    display_name=$1
    destination_path=$2

    if ! is_interactive; then
        printf 'Skipping overwrite of %s for %s because install is non-interactive.\n' "$destination_path" "$display_name" >&2
        return 1
    fi

    if [ -r /dev/tty ]; then
        printf "Overwrite existing instructions file '%s' for %s? [y/N] " "$destination_path" "$display_name" > /dev/tty
        IFS= read -r response < /dev/tty || response=""
    else
        printf "Overwrite existing instructions file '%s' for %s? [y/N] " "$destination_path" "$display_name"
        IFS= read -r response || response=""
    fi

    normalized=$(printf '%s' "$response" | tr '[:upper:]' '[:lower:]')
    [ "$normalized" = "y" ] || [ "$normalized" = "yes" ]
}

install_global_instructions() {
    display_name=$1
    source_path=$2
    destination_path=$3

    [ -n "$destination_path" ] || return

    created_by_installer=1
    if [ -e "$destination_path" ]; then
        created_by_installer=0
        if [ "$OVERWRITE_INSTRUCTIONS" -ne 1 ]; then
            if [ "$DRY_RUN" -eq 1 ]; then
                log_stderr "Would ask whether to overwrite existing instructions file '$destination_path' for $display_name."
                return
            fi

            if ! confirm_instructions_overwrite "$display_name" "$destination_path"; then
                log_stderr "Keeping existing instructions file '$destination_path'."
                return
            fi
        fi
    fi

    ensure_dir "$(dirname "$destination_path")"

    if [ "$DRY_RUN" -eq 1 ]; then
        if [ "$created_by_installer" -eq 1 ]; then
            log_stderr "Would install global instructions to '$destination_path'."
        else
            log_stderr "Would overwrite global instructions at '$destination_path'."
        fi
    else
        cp "$source_path" "$destination_path"
    fi

    printf 'instructions_file=%s\n' "$destination_path"
    printf 'instructions_file_created=%s\n' "$created_by_installer"
    printf 'instructions_mode=file\n'
}

get_instructions_metadata() {
    display_name=$1
    instructions_relative=$2

    if [ "$IGNORE_INSTRUCTIONS" -eq 1 ]; then
        log_stderr "Skipping provider-level global instructions for $display_name."
        return
    fi

    [ -n "$instructions_relative" ] || return

    instructions_path=$(join_home_relative_path "$instructions_relative")
    install_global_instructions "$display_name" "$GLOBAL_INSTRUCTIONS_SOURCE" "$instructions_path"
}

write_provider_state() {
    provider_id=$1
    display_name=$2
    skills_dir=$3
    installed_skill_dirs=$4
    installed_at_utc=$5
    instructions_metadata=${6:-}
    state_path="$PROVIDER_STATE_ROOT/$provider_id.state"

    {
        printf 'provider=%s\n' "$provider_id"
        printf 'display_name=%s\n' "$display_name"
        printf 'skills_dir=%s\n' "$skills_dir"
        printf 'installed_skill_dirs=%s\n' "$installed_skill_dirs"
        printf 'installed_at_utc=%s\n' "$installed_at_utc"
        if [ -n "$instructions_metadata" ]; then
            printf '%s\n' "$instructions_metadata"
        fi
    } | write_file "$state_path"
}

selected_providers=""
old_ifs=$IFS
IFS=','
set -- $PROVIDER_ARG
IFS=$old_ifs

for candidate in "$@"; do
    candidate=$(printf '%s' "$candidate" | sed 's/^ *//; s/ *$//')
    [ -n "$candidate" ] || continue
    if [ "$candidate" = "all" ]; then
        selected_providers=$(list_available_providers | paste -sd ' ' -)
        break
    fi

    if is_supported_provider "$candidate"; then
        selected_providers="$selected_providers $candidate"
    else
        printf 'Skipping unsupported provider: %s\n' "$candidate" >&2
    fi
done

if [ -z "$(printf '%s' "$selected_providers" | tr -d ' ')" ]; then
    printf 'No supported providers selected.\n'
    exit 0
fi

if [ "$PROVIDER_ARG" = "all" ]; then
    # Log the provider set chosen by the default auto-selection path.
    log "Detected providers: $(provider_display_names $selected_providers)"
fi

for provider_id in $selected_providers; do
    manifest_path="$PROVIDERS_ROOT/$provider_id/manifest.json"
    state_path="$PROVIDER_STATE_ROOT/$provider_id.state"
    display_name=$(manifest_value displayName "$manifest_path")
    skills_relative=$(manifest_value skillsDir "$manifest_path")
    instructions_relative=$(manifest_value instructionsFile "$manifest_path")
    skills_dir=$(join_home_relative_path "$skills_relative")
    remove_legacy_hint_from_state "$state_path"
    installed_skill_dirs=$(copy_skill_library "$skills_dir")
    instructions_metadata=$(get_instructions_metadata "$display_name" "$instructions_relative")
    installed_at_utc=$(utc_now)

    write_provider_state \
        "$provider_id" \
        "$display_name" \
        "$skills_dir" \
        "$installed_skill_dirs" \
        "$installed_at_utc" \
        "$instructions_metadata"

    log "Installed Radforge for $display_name."
done
