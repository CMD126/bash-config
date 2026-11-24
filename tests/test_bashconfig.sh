#!/usr/bin/env bash
# Tests for bashconfig.sh. Uses a temporary BASHRC, never the real one.
# Usage: bash tests/test_bashconfig.sh
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/bashconfig.sh"
BEGIN_MARK="# >>> bash-config (CMD126) >>>"
END_MARK="# <<< bash-config (CMD126) <<<"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

failures=0
fail() { echo "FAIL: $*" >&2; failures=$((failures + 1)); }
pass() { echo "ok: $*"; }

# Fresh scratch bashrc with known content; sets BASHRC and exports it.
new_rc() {
    BASHRC="$WORK/$1/.bashrc"
    mkdir -p "$WORK/$1"
    printf '# my bashrc\nexport FOO=bar\nalias x=y\n' > "$BASHRC"
    cp "$BASHRC" "$WORK/$1/original"
    export BASHRC
}
run() { bash "$SCRIPT" "$@" > "$WORK/out" 2> "$WORK/err"; }
count() { grep -Fxc -- "$1" "$BASHRC" || true; }
count_backups() { find "$(dirname "$BASHRC")" -maxdepth 1 -name '.bashrc.bak.*' | wc -l | tr -d ' '; }

# 1. fresh install adds exactly one block
new_rc t1
if run; then
    b="$(count "$BEGIN_MARK")"; e="$(count "$END_MARK")"
    if [[ "$b" == 1 && "$e" == 1 ]]; then pass "fresh install adds one block"
    else fail "fresh install: expected 1 start and 1 end marker, got $b and $e"; fi
else fail "fresh install exited non-zero: $(cat "$WORK/err")"; fi

# 2. reinstall keeps exactly one block
if run; then
    b="$(count "$BEGIN_MARK")"; e="$(count "$END_MARK")"
    if [[ "$b" == 1 && "$e" == 1 ]]; then pass "reinstall keeps one block"
    else fail "reinstall: expected 1 start and 1 end marker, got $b and $e"; fi
else fail "reinstall exited non-zero: $(cat "$WORK/err")"; fi

# 3. uninstall restores the original byte for byte
if run --uninstall; then
    if cmp -s "$BASHRC" "$WORK/t1/original"; then pass "uninstall restores original byte for byte"
    else fail "uninstall: file differs from original"; diff "$WORK/t1/original" "$BASHRC" >&2 || true; fi
else fail "uninstall exited non-zero: $(cat "$WORK/err")"; fi

# 4. uninstall with end marker missing refuses and leaves the file unchanged
new_rc t4
run || fail "setup install for missing-end test failed"
grep -Fxv -- "$END_MARK" "$BASHRC" > "$WORK/t4/broken"
cp "$WORK/t4/broken" "$BASHRC"
before="$(find "$WORK/t4" -maxdepth 1 -name '.bashrc.bak.*' | wc -l | tr -d ' ')"
if run --uninstall; then
    fail "uninstall with missing end marker exited zero"
else
    if ! cmp -s "$BASHRC" "$WORK/t4/broken"; then fail "missing end marker: file was modified"
    elif ! grep -q "marker" "$WORK/err"; then fail "missing end marker: no clear message on stderr"
    elif [[ "$(count_backups)" != "$before" ]]; then fail "missing end marker: a backup was created"
    else pass "uninstall refuses when end marker is missing"; fi
fi

# 5. backup rotation keeps at most 3
new_rc t5
dir="$(dirname "$BASHRC")"
for n in 01 02 03 04 05 06; do
    printf 'old %s\n' "$n" > "$BASHRC.bak.202001$n-000000"
done
run || fail "install for rotation test failed"
n="$(count_backups)"
if [[ "$n" -le 3 ]]; then pass "backup rotation keeps at most 3 (found $n)"
else fail "backup rotation: expected at most 3 backups, found $n"; fi
if [[ ! -e "$BASHRC.bak.20200101-000000" && -e "$BASHRC.bak.20200106-000000" ]]; then
    pass "rotation deletes the oldest and keeps newer ones"
else fail "rotation did not delete the oldest backups first"; fi
# unrelated files must survive
printf 'keep\n' > "$dir/.bashrc.bak.manual"
run || fail "second install for rotation test failed"
if [[ -e "$dir/.bashrc.bak.manual" ]]; then pass "files not matching backup naming are kept"
else fail "rotation deleted a file that is not a script backup"; fi

if [[ "$failures" -gt 0 ]]; then
    echo "$failures test(s) failed" >&2
    exit 1
fi
echo "All tests passed"
