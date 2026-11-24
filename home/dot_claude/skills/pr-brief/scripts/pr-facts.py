#!/usr/bin/env python3
"""Collect the facts a PR review brief is built from.

Usage: pr-facts.py [--base <ref>] [--pr <number>] [--json]

Run from inside the repo checkout of the PR branch. Without --base it diffs against the
merge-base with origin/main (falling back to main). With --pr it also resolves the
GitHub owner/repo so file links point at the PR's "Files changed" tab.
"""

import argparse
import hashlib
import json
import os
import posixpath
import re
import subprocess
import sys

GENERATED_PATTERNS = [
    r"(^|/)pnpm-lock\.yaml$",
    r"(^|/)package-lock\.json$",
    r"(^|/)yarn\.lock$",
    r"(^|/)generated/",
    r"\.generated\.",
    r"(^|/)__snapshots__/",
    r"\.snap$",
    r"(^|/)schema\.gql$",
    r"(^|/)dist/",
]
TEST_PATTERN = re.compile(r"(\.spec\.|\.test\.|\.unit\.|\.e2e\.|\.e2e-spec\.|(^|/)e2e/|(^|/)test/|(^|/)__tests__/)")
BOILERPLATE_PATTERN = re.compile(r"(\.dto|\.types?|\.module|\.consts?|\.error|\.enum|\.input|\.args|\.model|/index)\.tsx?$|(^|/)(dtos|types|errors|enums)/")
CODE_EXTENSIONS = (".ts", ".tsx", ".js", ".jsx", ".mts", ".cts")

REVIEWER_MAGNETS = [
    ("raw SQL", r"\$queryRaw|\$executeRaw|queryRawUnsafe|executeRawUnsafe|Prisma\.sql|Prisma\.raw"),
    ("type escape", r"as unknown as|:\s*any\b|<any>|as any\b"),
    ("lint/type suppression", r"eslint-disable|oxlint-disable|@ts-ignore|@ts-expect-error|@ts-nocheck"),
    ("forwardRef", r"forwardRef\("),
    ("focused/skipped test", r"\b(it|describe|test)\.(only|skip)\(|\bxit\(|\bxdescribe\("),
    ("TODO/FIXME", r"\bTODO\b|\bFIXME\b|\bHACK\b|\bXXX\b"),
    ("new env read", r"process\.env\.[A-Z_]+"),
    ("timer/sleep", r"setTimeout\(|setInterval\(|\bsleep\("),
    ("console output", r"console\.(log|warn|error|debug)\("),
    ("transaction", r"\$transaction\(|TransactionClient|\.withTransaction\("),
    ("swallowed error", r"catch\s*(\(\s*\w*\s*\))?\s*\{\s*\}"),
    ("hand-built Logger", r"new Logger\("),
    ("non-null assertion", r"\w!\.\w"),
]


def git(*args, check=True):
    result = subprocess.run(["git", *args], capture_output=True, text=True)
    if check and result.returncode != 0:
        sys.exit(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout


def gh_json(*args):
    result = subprocess.run(["gh", *args], capture_output=True, text=True)
    if result.returncode != 0:
        return None
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError:
        return None


def is_generated(path):
    return any(re.search(p, path) for p in GENERATED_PATTERNS)


def is_test(path):
    return bool(TEST_PATTERN.search(path))


def area_of(path):
    parts = path.split("/")
    if parts[0] == "src" and len(parts) >= 3:
        if parts[1] in ("modules", "graphql", "rest", "mcp", "jobs", "common", "apps", "database") and len(parts) >= 4:
            return f"{parts[1]}/{parts[2]}"
        return f"src/{parts[1]}"
    if parts[0] == "resources" and len(parts) >= 2:
        return f"resources/{parts[1]}"
    if len(parts) == 1:
        return "(root)"
    return parts[0]


def resolve_base(explicit):
    if explicit:
        return git("merge-base", explicit, "HEAD").strip(), explicit
    for candidate in ("origin/main", "main", "origin/master", "master"):
        result = subprocess.run(["git", "merge-base", candidate, "HEAD"], capture_output=True, text=True)
        if result.returncode == 0:
            return result.stdout.strip(), candidate
    sys.exit("could not find a base: pass --base")


def load_aliases():
    try:
        raw = open("tsconfig.json").read()
    except OSError:
        return []
    raw = re.sub(r"^\s*//.*$", "", raw, flags=re.M)
    raw = re.sub(r",(\s*[}\]])", r"\1", raw)
    try:
        paths = json.loads(raw).get("compilerOptions", {}).get("paths", {})
    except json.JSONDecodeError:
        return []
    aliases = []
    for alias, targets in paths.items():
        if not targets:
            continue
        prefix = alias.rstrip("*")
        target = targets[0].lstrip("./").rstrip("*")
        aliases.append((prefix, target))
    aliases.sort(key=lambda a: -len(a[0]))
    return aliases


IMPORT_RE = re.compile(r"""(?:from\s+|import\s*\(\s*|require\s*\(\s*|^\s*import\s+)['"]([^'"]+)['"]""", re.M)


def import_targets(source_path, content, aliases):
    targets = set()
    for spec in IMPORT_RE.findall(content):
        resolved = None
        if spec.startswith("."):
            resolved = posixpath.normpath(posixpath.join(posixpath.dirname(source_path), spec))
        else:
            for prefix, target in aliases:
                if spec.startswith(prefix):
                    resolved = target + spec[len(prefix):]
                    break
        if resolved:
            targets.add(area_of(resolved + "/x"))
    return targets


def file_at(ref, path):
    result = subprocess.run(["git", "show", f"{ref}:{path}"], capture_output=True, text=True)
    return result.stdout if result.returncode == 0 else None


def package_deps(ref):
    content = file_at(ref, "package.json") if ref else open("package.json").read() if os.path.exists("package.json") else None
    if not content:
        return {}
    try:
        data = json.loads(content)
    except json.JSONDecodeError:
        return {}
    deps = {}
    for section in ("dependencies", "devDependencies", "peerDependencies"):
        for name, version in data.get(section, {}).items():
            deps[name] = f"{version} ({section})"
    return deps


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--base")
    parser.add_argument("--pr")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    base, base_name = resolve_base(args.base)
    head = git("rev-parse", "HEAD").strip()
    branch = git("rev-parse", "--abbrev-ref", "HEAD").strip()

    repo_slug = None
    pr_info = None
    if args.pr:
        pr_info = gh_json("pr", "view", args.pr, "--json", "number,url,title,body,baseRefName,headRefName,headRefOid")
    else:
        pr_info = gh_json("pr", "view", "--json", "number,url,title,body,baseRefName,headRefName,headRefOid")
    if pr_info:
        match = re.match(r"https://github\.com/([^/]+/[^/]+)/pull/", pr_info["url"])
        repo_slug = match.group(1) if match else None

    commits = [line for line in git("log", "--format=%h %s", f"{base}..HEAD").splitlines() if line]

    files = []
    renames = []
    for line in git("diff", "--name-status", "-M", f"{base}...HEAD").splitlines():
        parts = line.split("\t")
        status = parts[0]
        if status.startswith("R"):
            similarity = int(status[1:] or 0)
            renames.append({"from": parts[1], "to": parts[2], "similarity": similarity})
            files.append({"path": parts[2], "old_path": parts[1], "status": "R", "similarity": similarity})
        else:
            files.append({"path": parts[1], "status": status[0]})

    numstat = {}
    for line in git("diff", "--numstat", "-M", f"{base}...HEAD").splitlines():
        added, deleted, path = line.split("\t", 2)
        if " => " in path:
            path = re.sub(r"\{([^{}]*) => ([^{}]*)\}", r"\2", path)
            path = path.split(" => ")[-1].replace("//", "/")
        numstat[path] = (0 if added == "-" else int(added), 0 if deleted == "-" else int(deleted))

    for f in files:
        added, deleted = numstat.get(f["path"], (0, 0))
        f["added"], f["deleted"] = added, deleted
        f["generated"] = is_generated(f["path"])
        f["test"] = is_test(f["path"])
        f["area"] = area_of(f["path"])
        if repo_slug and pr_info:
            digest = hashlib.sha256(f["path"].encode()).hexdigest()
            f["diff_url"] = f"https://github.com/{repo_slug}/pull/{pr_info['number']}/files#diff-{digest}"

    reviewable = [f for f in files if not f["generated"]]
    source = [f for f in reviewable if not f["test"] and f["path"].endswith(CODE_EXTENSIONS + (".prisma", ".sql", ".gql", ".graphql"))]

    areas = {}
    for f in reviewable:
        a = areas.setdefault(f["area"], {"files": 0, "added": 0, "deleted": 0, "tests": 0})
        a["files"] += 1
        a["added"] += f["added"]
        a["deleted"] += f["deleted"]
        a["tests"] += 1 if f["test"] else 0

    aliases = load_aliases()
    edges_before, edges_after = set(), set()
    for f in source:
        if not f["path"].endswith(CODE_EXTENSIONS):
            continue
        old_path = f.get("old_path", f["path"])
        if f["status"] != "A":
            before = file_at(base, old_path)
            if before:
                for target in import_targets(old_path, before, aliases):
                    if target != area_of(old_path):
                        edges_before.add((area_of(old_path), target))
        if f["status"] != "D" and os.path.exists(f["path"]):
            after = open(f["path"], encoding="utf-8", errors="replace").read()
            for target in import_targets(f["path"], after, aliases):
                if target != f["area"]:
                    edges_after.add((f["area"], target))

    magnets = []
    diff_text = git("diff", "-U0", "-M", f"{base}...HEAD", "--", ".", ":(exclude)*.lock", ":(exclude)pnpm-lock.yaml")
    current_file, current_line = None, 0
    for line in diff_text.splitlines():
        if line.startswith("+++ "):
            current_file = line[6:] if line.startswith("+++ b/") else None
            continue
        hunk = re.match(r"@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@", line)
        if hunk:
            current_line = int(hunk.group(1))
            continue
        if line.startswith("+") and current_file and not is_generated(current_file):
            for label, pattern in REVIEWER_MAGNETS:
                if label in ("focused/skipped test",) and not is_test(current_file):
                    continue
                if re.search(pattern, line):
                    magnets.append({"kind": label, "file": current_file, "line": current_line, "text": line[1:].strip()[:160]})
            current_line += 1

    migrations = [f["path"] for f in files if re.search(r"migrations?/.+\.(sql|ts)$", f["path"]) and f["status"] == "A"]
    schema_files = [f["path"] for f in files if f["path"].endswith(".prisma")]
    api_surface = [f["path"] for f in files if re.search(r"\.(resolver|controller)\.ts$|\.gql$|(^|/)mcp/.+tools?\.ts$|\.tools\.ts$", f["path"])]
    jobs = [f["path"] for f in files if re.search(r"\.(processor|consumer|publisher|queue)\.ts$|(^|/)jobs/", f["path"]) and not f["test"]]
    docs = [f["path"] for f in files if f["path"].endswith(".md")]
    runbooks = [f["path"] for f in files if "runbooks/" in f["path"]]

    deps_before, deps_after = package_deps(base), package_deps(None)
    dep_changes = []
    for name in sorted(set(deps_before) | set(deps_after)):
        if deps_before.get(name) != deps_after.get(name):
            dep_changes.append({"name": name, "before": deps_before.get(name), "after": deps_after.get(name)})

    changed_paths = {f["path"] for f in files}
    untested = []
    for f in source:
        if not f["path"].endswith(CODE_EXTENSIONS) or f["status"] == "D" or f["added"] < 15 or BOILERPLATE_PATTERN.search(f["path"]):
            continue
        stem = re.sub(r"\.(ts|tsx|js|jsx)$", "", os.path.basename(f["path"]))
        if not any(stem in p and is_test(p) for p in changed_paths):
            untested.append(f["path"])

    total_added = sum(f["added"] for f in reviewable)
    total_deleted = sum(f["deleted"] for f in reviewable)
    source_lines = sum(f["added"] + f["deleted"] for f in source)
    source_areas = {f["area"] for f in source}
    moved_source = [r for r in renames if not is_test(r["to"]) and posixpath.dirname(r["from"]) != posixpath.dirname(r["to"])]

    triggers = []
    if len(source) >= 15:
        triggers.append(f"{len(source)} non-test source files")
    if source_lines >= 600:
        triggers.append(f"{source_lines} non-test lines changed")
    if len(source_areas) >= 3:
        triggers.append(f"{len(source_areas)} areas touched: {', '.join(sorted(source_areas))}")
    if moved_source:
        triggers.append(f"{len(moved_source)} files moved between directories")
    if edges_after ^ edges_before:
        triggers.append(f"cross-area imports changed (+{len(edges_after - edges_before)} / -{len(edges_before - edges_after)})")
    if migrations or schema_files:
        triggers.append("database schema / migration change")
    if dep_changes:
        triggers.append(f"{len(dep_changes)} package dependency changes")
    if any(m["kind"] == "raw SQL" for m in magnets):
        triggers.append("raw SQL added")
    if jobs:
        triggers.append("queue / job code changed")
    if any(f["status"] == "A" and f["path"].endswith(".module.ts") for f in files):
        triggers.append("new Nest module")
    if any(f["status"] == "D" and f["path"].endswith(".module.ts") for f in files):
        triggers.append("Nest module removed")

    facts = {
        "branch": branch,
        "base": base_name,
        "base_sha": base,
        "head_sha": head,
        "repo": repo_slug,
        "pr": pr_info,
        "commits": commits,
        "totals": {
            "files": len(files),
            "reviewable_files": len(reviewable),
            "source_files": len(source),
            "test_files": sum(1 for f in reviewable if f["test"]),
            "other_files": sum(1 for f in reviewable if not f["test"]) - len(source),
            "generated_files": len(files) - len(reviewable),
            "added": total_added,
            "deleted": total_deleted,
        },
        "areas": dict(sorted(areas.items(), key=lambda kv: -(kv[1]["added"] + kv[1]["deleted"]))),
        "files": files,
        "renames": renames,
        "import_edges_added": sorted(edges_after - edges_before),
        "import_edges_removed": sorted(edges_before - edges_after),
        "import_edges_after": sorted(edges_after),
        "migrations": migrations,
        "schema_files": schema_files,
        "api_surface": api_surface,
        "jobs": jobs,
        "docs": docs,
        "runbooks": runbooks,
        "dependency_changes": dep_changes,
        "reviewer_magnets": magnets,
        "source_without_test_change": untested,
        "artifact_triggers": triggers,
    }

    if args.json:
        print(json.dumps(facts, indent=2))
        return

    out = []
    out.append(f"# PR facts: {branch} vs {base_name} ({base[:9]}..{head[:9]})")
    if pr_info:
        out.append(f"PR #{pr_info['number']}: {pr_info['title']} - {pr_info['url']}")
    t = facts["totals"]
    out.append(f"\n## Size\n{t['reviewable_files']} reviewable files ({t['source_files']} source, {t['test_files']} test, {t['other_files']} docs/config), "
               f"{t['generated_files']} generated/lock skipped, +{t['added']} / -{t['deleted']}, {len(commits)} commits")
    out.append("\n## Areas (reviewable files)")
    for name, a in facts["areas"].items():
        out.append(f"- {name}: {a['files']} files ({a['tests']} test), +{a['added']} / -{a['deleted']}")
    out.append("\n## Commits")
    out.extend(f"- {c}" for c in commits)
    out.append("\n## Files")
    for f in files:
        flags = [x for x, on in (("generated", f["generated"]), ("test", f["test"])) if on]
        moved = f" (from {f['old_path']}, {f['similarity']}%)" if f["status"] == "R" else ""
        out.append(f"- {f['status']} {f['path']}{moved} +{f['added']}/-{f['deleted']}" + (f" [{', '.join(flags)}]" if flags else ""))
    if renames:
        out.append("\n## Moves / renames")
        out.extend(f"- {r['from']} -> {r['to']} ({r['similarity']}%)" for r in renames)
    out.append("\n## Cross-area import edges")
    out.append("added: " + (", ".join(f"{a} -> {b}" for a, b in facts["import_edges_added"]) or "none"))
    out.append("removed: " + (", ".join(f"{a} -> {b}" for a, b in facts["import_edges_removed"]) or "none"))
    changed_sources = {a for a, _ in facts["import_edges_added"]} | {a for a, _ in facts["import_edges_removed"]}
    out.append("current edges of the areas whose edges changed:")
    for src in sorted(changed_sources):
        targets = sorted(b for a, b in facts["import_edges_after"] if a == src)
        shown = ", ".join(targets) if len(targets) <= 15 else f"{len(targets)} areas (aggregator)"
        out.append(f"- {src} -> {shown}")
    for title, key in (("Migrations (new)", "migrations"), ("Prisma schema files", "schema_files"),
                       ("API surface (resolvers/controllers/MCP tools)", "api_surface"), ("Jobs / queues", "jobs"),
                       ("Runbooks", "runbooks"), ("Docs", "docs"),
                       ("Source files with 15+ added lines and no matching test change", "source_without_test_change")):
        if facts[key]:
            out.append(f"\n## {title}")
            out.extend(f"- {p}" for p in facts[key])
    if dep_changes:
        out.append("\n## Dependency changes")
        out.extend(f"- {d['name']}: {d['before'] or '(none)'} -> {d['after'] or '(removed)'}" for d in dep_changes)
    if magnets:
        out.append("\n## Reviewer magnets (added lines)")
        out.extend(f"- [{m['kind']}] {m['file']}:{m['line']}  {m['text']}" for m in magnets)
    out.append("\n## Artifact triggers")
    out.extend(f"- {tr}" for tr in triggers) if triggers else out.append("- none: description-only is the default")
    print("\n".join(out))


if __name__ == "__main__":
    main()
