#!/bin/sh
set -eu

PROVIDER_ARG="all"
HOME_ROOT="${HOME:-}"
DRY_RUN=0

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

STATE_ROOT="$HOME_ROOT/.radforge"
PROVIDER_STATE_ROOT="$STATE_ROOT/providers"
MARKER_START='<!-- RADFORGE:BEGIN -->'
MARKER_END='<!-- RADFORGE:END -->'

log() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] %s\n' "$1"
    else
        printf '[radforge] %s\n' "$1"
    fi
}

utc_now() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
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

write_file() {
    path=$1
    parent=$(dirname "$path")

    if [ "$DRY_RUN" -eq 1 ]; then
        log "Would write file '$path'."
        return
    fi

    mkdir -p "$parent"
    tmp=$(mktemp)
    cat > "$tmp"
    mv "$tmp" "$path"
}

state_value() {
    key=$1
    file=$2
    sed -n "s/^$key=//p" "$file" | head -n 1
}

installed_provider_display_names() {
    first=1
    for provider_id in "$@"; do
        state_path="$PROVIDER_STATE_ROOT/$provider_id.state"
        [ -f "$state_path" ] || continue
        display_name=$(state_value display_name "$state_path")
        if [ "$first" -eq 0 ]; then
            printf ', '
        fi
        printf '%s' "$display_name"
        first=0
    done
    printf '\n'
}

remove_empty_state_dirs() {
    has_provider_states=0
    if [ -d "$PROVIDER_STATE_ROOT" ]; then
        for state_path in "$PROVIDER_STATE_ROOT"/*.state; do
            [ -f "$state_path" ] || continue
            has_provider_states=1
            break
        done
    fi

    if [ "$has_provider_states" -eq 0 ]; then
        if [ -d "$PROVIDER_STATE_ROOT" ] && [ "$DRY_RUN" -eq 0 ]; then
            rmdir "$PROVIDER_STATE_ROOT" 2>/dev/null || true
        fi
    fi

    if [ -d "$STATE_ROOT" ] && [ "$DRY_RUN" -eq 0 ]; then
        rmdir "$STATE_ROOT" 2>/dev/null || true
    fi
}

strip_managed_block() {
    file_path=$1
    tmp=$(mktemp)
    awk -v start="$MARKER_START" -v end="$MARKER_END" '
        BEGIN { inside = 0 }
        $0 == start { inside = 1; next }
        $0 == end { inside = 0; next }
        !inside { print }
    ' "$file_path" > "$tmp"

    printf '%s\n' "$tmp"
}

if [ ! -d "$PROVIDER_STATE_ROOT" ]; then
    printf 'No Radforge provider state found.\n'
    exit 0
fi

selected_providers=""
old_ifs=$IFS
IFS=','
set -- $PROVIDER_ARG
IFS=$old_ifs

if [ "$PROVIDER_ARG" = "all" ]; then
    for state_path in "$PROVIDER_STATE_ROOT"/*.state; do
        [ -f "$state_path" ] || continue
        selected_providers="$selected_providers $(basename "$state_path" .state)"
    done
else
    for candidate in "$@"; do
        candidate=$(printf '%s' "$candidate" | sed 's/^ *//; s/ *$//')
        [ -n "$candidate" ] || continue
        if [ -f "$PROVIDER_STATE_ROOT/$candidate.state" ]; then
            selected_providers="$selected_providers $candidate"
        else
            printf 'Skipping provider without install state: %s\n' "$candidate" >&2
        fi
    done
fi

if [ "$PROVIDER_ARG" = "all" ] && [ -n "$(printf '%s' "$selected_providers" | tr -d ' ')" ]; then
    log "Detected providers: $(installed_provider_display_names $selected_providers)"
fi

for provider_id in $selected_providers; do
    state_path="$PROVIDER_STATE_ROOT/$provider_id.state"
    [ -f "$state_path" ] || continue
    display_name=$(state_value display_name "$state_path")
    instructions_file=$(state_value instructions_file "$state_path")
    instructions_file_created=$(state_value instructions_file_created "$state_path")
    installed_skill_dirs=$(state_value installed_skill_dirs "$state_path")

    if [ -f "$instructions_file" ]; then
        stripped_file=$(strip_managed_block "$instructions_file")
        if [ ! -s "$stripped_file" ] && [ "$instructions_file_created" = "1" ]; then
            remove_path_if_exists "$instructions_file"
        else
            cat "$stripped_file" | write_file "$instructions_file"
        fi
        rm -f "$stripped_file"
    fi

    old_ifs=$IFS
    IFS='|'
    set -- $installed_skill_dirs
    IFS=$old_ifs
    for skill_dir in "$@"; do
        [ -n "$skill_dir" ] || continue
        remove_path_if_exists "$skill_dir"
    done

    remove_path_if_exists "$state_path"
    log "Uninstalled Radforge for $display_name."
done

remove_empty_state_dirs
