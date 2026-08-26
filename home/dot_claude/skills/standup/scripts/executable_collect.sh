#!/usr/bin/env bash
# Collect a raw activity digest (git + Claude sessions) for a date window.
# Emits plain text on stdout. Does not interpret anything - that is the agent's job.
set -uo pipefail

ROOTS_DEFAULT="$HOME/Work/Pump $HOME/Projects"
ROOTS="${STANDUP_ROOTS:-$ROOTS_DEFAULT}"
PROJECTS_DIR="$HOME/.claude/projects"
MAX_PROMPTS="${STANDUP_MAX_PROMPTS:-14}"
MAX_PROMPT_CHARS="${STANDUP_MAX_PROMPT_CHARS:-220}"

usage() {
  cat >&2 <<'USAGE'
usage: collect.sh [WINDOW]

WINDOW forms:
  (none)              2 days back; on a Monday, back to Friday 00:00
  3d | 5d             N days back, from 00:00
  today | yesterday
  week                back to Monday 00:00
  YYYY-MM-DD          from that date 00:00 until now
  YYYY-MM-DD..YYYY-MM-DD   explicit range (end date inclusive)
USAGE
  exit 2
}

day_epoch() { date -j -f '%Y-%m-%d %H:%M:%S' "$1 00:00:00" +%s 2>/dev/null; }
utc()       { date -u -r "$1" +%Y-%m-%dT%H:%M:%SZ; }
back()      { date -v-"$1"d +%Y-%m-%d; }

resolve_window() {
  local arg="${1:-}"
  case "$arg" in
    '')
      # Monday reaches back over the weekend to Friday, every other day is -2d.
      if [ "$(date +%u)" = "1" ]; then SINCE_D=$(back 3); else SINCE_D=$(back 2); fi
      UNTIL_D=''
      ;;
    today)      SINCE_D=$(date +%Y-%m-%d); UNTIL_D='' ;;
    yesterday)  SINCE_D=$(back 1); UNTIL_D=$(date +%Y-%m-%d) ;;
    week)       SINCE_D=$(back $(( $(date +%u) - 1 ))); UNTIL_D='' ;;
    [0-9]*d)    SINCE_D=$(back "${arg%d}"); UNTIL_D='' ;;
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]..[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9])
      SINCE_D="${arg%%..*}"
      UNTIL_D=$(date -j -v+1d -f '%Y-%m-%d' "${arg##*..}" +%Y-%m-%d)
      ;;
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) SINCE_D="$arg"; UNTIL_D='' ;;
    *) usage ;;
  esac

  local se; se=$(day_epoch "$SINCE_D") || usage
  [ -z "$se" ] && usage
  SINCE_LOCAL="$SINCE_D 00:00:00"
  SINCE_UTC=$(utc "$se")
  if [ -n "$UNTIL_D" ]; then
    UNTIL_LOCAL="$UNTIL_D 00:00:00"
    UNTIL_UTC=$(utc "$(day_epoch "$UNTIL_D")")
  else
    UNTIL_LOCAL=$(date +'%Y-%m-%d %H:%M:%S')
    UNTIL_UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  fi
}

resolve_window "${1:-}"

EMAIL=$(git config --global user.email 2>/dev/null || echo '')
[ -z "$EMAIL" ] && EMAIL=$(git -C "$PWD" config user.email 2>/dev/null || echo '')

echo "# WINDOW"
echo "since: $SINCE_LOCAL (local)  /  $SINCE_UTC"
echo "until: $UNTIL_LOCAL (local)  /  $UNTIL_UTC"
echo "author: ${EMAIL:-<unset>}   today: $(date +'%Y-%m-%d %A')"
echo

echo "# GIT"
for root in $ROOTS; do
  [ -d "$root" ] || continue
  for repo in "$root"/*; do
    [ -e "$repo/.git" ] || continue
    name="${repo#$HOME/}"

    commits=$(git -C "$repo" log --all --no-merges \
      ${EMAIL:+--author="$EMAIL"} \
      --since="$SINCE_LOCAL" --until="$UNTIL_LOCAL" \
      --pretty=format:'  %cd %h %d %s' --date=format:'%m-%d %H:%M' 2>/dev/null)
    merges=$(git -C "$repo" log --all --merges \
      ${EMAIL:+--author="$EMAIL"} \
      --since="$SINCE_LOCAL" --until="$UNTIL_LOCAL" \
      --pretty=format:'  %cd %h MERGE %s' --date=format:'%m-%d %H:%M' 2>/dev/null)
    # Uncommitted work, main checkout plus every mn worktree.
    dirty=''
    while read -r wt; do
      [ -z "$wt" ] && continue
      st=$(git -C "$wt" status --porcelain 2>/dev/null | head -25)
      [ -z "$st" ] && continue
      br=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null)
      dirty+="  uncommitted @ ${wt#$HOME/} [$br]"$'\n'
      dirty+=$(echo "$st" | sed 's/^/    /')$'\n'
    done < <(git -C "$repo" worktree list --porcelain 2>/dev/null | rg -N '^worktree ' | sed 's/^worktree //')

    [ -z "$commits$merges$dirty" ] && continue
    echo "## $name"
    [ -n "$commits" ] && echo "$commits"
    [ -n "$merges" ]  && echo "$merges"
    [ -n "$dirty" ]   && printf '%s' "$dirty"

    if command -v gh >/dev/null 2>&1 && git -C "$repo" remote get-url origin 2>/dev/null | rg -qN github.com; then
      prs=$(cd "$repo" && GH_PAGER=cat timeout 15 gh pr list --author '@me' --state all --limit 20 \
        --json number,title,state,updatedAt,url \
        --jq ".[] | select(.updatedAt >= \"$SINCE_UTC\") | \"  PR #\(.number) [\(.state)] \(.title)\"" 2>/dev/null)
      [ -n "$prs" ] && echo "$prs"
    fi
    echo
  done
done
echo

echo "# CLAUDE SESSIONS"
[ -d "$PROJECTS_DIR" ] || { echo "(no ~/.claude/projects)"; exit 0; }

US=$(printf '\037')

while read -r f; do
  [ -z "$f" ] && continue

  meta=$(jq -rs --arg s "$SINCE_UTC" --arg u "$UNTIL_UTC" --arg sep "$US" '
    (map(select(.type=="ai-title")) | last | .aiTitle // "<untitled>") as $title
    | (map(select(.type=="user" and .timestamp >= $s and .timestamp < $u))) as $inw
    | if ($inw|length) == 0 then empty
      else [ ($inw|first|.cwd // "?"), ($inw|first|.gitBranch // ""), $title,
             ($inw|first|.timestamp|.[5:16]), ($inw|last|.timestamp|.[5:16]),
             ($inw|length|tostring) ] | join($sep)
      end' "$f" 2>/dev/null)
  [ -z "$meta" ] && continue

  IFS="$US" read -r cwd branch title tfrom tto n <<<"$meta"

  # One line per prompt: newlines folded, pasted logs and stack frames dropped.
  prompts=$(jq -r --arg s "$SINCE_UTC" --arg u "$UNTIL_UTC" '
    select(.type=="user" and (.isMeta|not) and (.message.content|type=="string")
           and .timestamp >= $s and .timestamp < $u)
    | .message.content
    | split("\n")
    | map(select(test("^\\s*$|^\\s*<|^Caveat:|^Shell cwd was reset|^\\s{2,}at |^\\[api\\]|^\\s*[0-9]{2}:[0-9]{2}:[0-9]{2}") | not))
    | join(" / ")' "$f" 2>/dev/null \
    | rg -Nv '^\s*$' | awk '!seen[$0]++')

  [ -z "$(printf '%s' "$prompts" | tr -d '[:space:]')" ] && continue

  first=$(printf '%s\n' "$prompts" | head -1)
  auto=''
  case "$first" in
    'Generate a concise release title'*|'You are writing release notes'*|\
    '# Resolve a staging merge conflict'*|'Summarize what I did'*|'You are an expert'*)
      auto=' [automation]' ;;
  esac

  echo "## ${cwd#$HOME/}${branch:+ [$branch]}$auto"
  echo "   title: $title   |   $tfrom -> $tto UTC   |   $n prompts"
  if [ -n "$auto" ]; then
    printf '   - %s\n' "$(printf '%s' "$first" | cut -c1-120)"
  else
    printf '%s\n' "$prompts" | head -"$MAX_PROMPTS" | cut -c1-"$MAX_PROMPT_CHARS" | sed 's/^/   - /'
  fi
  echo
done < <(fd -HI -e jsonl --changed-after "$SINCE_D" . "$PROJECTS_DIR" 2>/dev/null | rg -Nv '/subagents/')
