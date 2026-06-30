# Spotlight Dev Ignore

`Spotlight Dev Ignore` is a macOS CLI utility for developers that reduces
Spotlight indexing overhead by selectively excluding dependency, cache,
build, and generated directories while leaving source code searchable.

## What changed in v2

- Dedicated state directory: `~/.config/spotlight-dev_v2/`
- No manual setup required
- Proper command-based CLI
- Clearer source filename: `./spotlight-dev-ignore`
- Installable as `/usr/local/bin/spotlight-dev-ignore`
- Backward-compatible legacy flags still work

On first run, the tool automatically creates:

```text
~/.config/spotlight-dev_v2/
├── applied.txt
└── optimize-spotlight-dev.log
```

No manual `mkdir` or `touch` steps are required.

---

## Why this tool exists

Development projects often contain hundreds of thousands of generated files
that provide little value in Spotlight searches but consume CPU, disk I/O,
and indexing time.

Instead of disabling Spotlight entirely, this utility creates
`.metadata_never_index` markers only in directories that are safe to exclude.

Source code, documentation, configuration, and assets remain indexed.

---

## Supported Technologies

- JavaScript / Node.js
- PHP / Composer
- Laravel
- WordPress
- Joomla
- Python

## Automatically excluded

### General

- `node_modules`
- `vendor`
- `.venv`, `venv`, `env`
- `__pycache__`
- `.tox`
- `.nox`
- `.pytest_cache`
- `.mypy_cache`
- `.ruff_cache`
- `.coverage`
- `coverage`
- `htmlcov`
- `build`
- `dist`
- `.next`
- `.nuxt`
- `.parcel-cache`
- `.turbo`
- `.cache`
- `.vite`
- `.rollup.cache`
- `.eslintcache`
- `.stylelintcache`
- `.sass-cache`
- `bower_components`
- `.gradle`

### Laravel

- `bootstrap/cache`
- `storage/framework/cache`
- `storage/framework/views`
- `storage/framework/sessions`
- `storage/framework/testing`
- `storage/logs`

---

## Commands

### Install globally

```bash
./spotlight-dev-ignore install
```

This installs the CLI to:

```text
/usr/local/bin/spotlight-dev-ignore
```

After that you can run it from anywhere:

```bash
spotlight-dev-ignore doctor
spotlight-dev-ignore scan --dry-run ~/Documents
```

### Update the installed CLI

```bash
./spotlight-dev-ignore update
```

### Uninstall the global CLI

```bash
spotlight-dev-ignore uninstall
```

This removes the binary but preserves your state directory.

### Run diagnostics

```bash
spotlight-dev-ignore doctor
```

### View status

```bash
spotlight-dev-ignore status
```

### Preview a scan

```bash
spotlight-dev-ignore scan --dry-run ~/Documents ~/Sites
```

### Apply markers

```bash
spotlight-dev-ignore scan --apply ~/Documents ~/Sites ~/Work
```

### Apply markers with verbose output

```bash
spotlight-dev-ignore scan --apply ~/Documents --verbose
```

### Restart Spotlight after applying or undoing

```bash
spotlight-dev-ignore scan --apply ~/Documents --restart-mds
spotlight-dev-ignore undo --restart-mds
```

### Undo managed markers

```bash
spotlight-dev-ignore undo
```

### Preview undo

```bash
spotlight-dev-ignore undo --dry-run
```

### Clean the audit log

```bash
spotlight-dev-ignore clean-log
```

---

## Tested on MacOS Big Sur Version 11.7.11

---

## Legacy compatibility

The previous flag-based workflow still works:

```bash
./spotlight-dev-ignore.sh --dry-run ~/Documents
./spotlight-dev-ignore.sh --apply ~/Documents
./spotlight-dev-ignore.sh --status
./spotlight-dev-ignore.sh --undo
```

Those commands delegate to `./spotlight-dev-ignore` and now use the
new v2 config directory.

---

## Files created automatically

### `applied.txt`

Tracks every directory managed by the utility.

Used to:

- avoid duplicate work
- safely perform undo
- detect deleted projects
- adopt existing markers

### `optimize-spotlight-dev.log`

Keeps a timestamped audit trail of:

- scan roots
- directories marked
- existing markers adopted
- skipped directories
- removed state entries
- warnings
- summary statistics

---

## Viewing the log

```bash
cat ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
tail -f ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
tail -100 ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
grep MARKED ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
grep WARN ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
```

## Viewing the state database

```bash
cat ~/.config/spotlight-dev_v2/applied.txt
wc -l ~/.config/spotlight-dev_v2/applied.txt
```

---

## Example log

```text
2026-06-29 22:15:04 [SCAN] /Users/[user name]/Documents
2026-06-29 22:15:04 [MARKED] /Users/[user name]/Documents/project/node_modules
2026-06-29 22:15:05 [ADOPTED] Marker already existed; adding to state
2026-06-29 22:15:05 [SKIP] Already marked and recorded
2026-06-29 22:15:06 [MISSING] /Users/[user name]/Documents/deleted-project/node_modules
2026-06-29 22:15:07 [SUMMARY] command=scan mode=apply targets=18 marked=18 already_marked=214 adopted_existing=3
```

---

## Best Practices

- Run after cloning new repositories.
- Run periodically as projects evolve.
- Review with `scan --dry-run` before large scans.
- Keep the log for auditing.
- Do not place `.metadata_never_index` in source directories.

---

## License

Free to modify and use for personal or commercial development workflows.
