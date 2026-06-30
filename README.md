# Spotlight Dev Ignore

`Spotlight Dev Ignore` is a macOS CLI utility for developers that reduces
Spotlight indexing overhead by selectively excluding dependency, cache,
build, and generated directories while leaving source code searchable.

## At a glance

- Local source CLI: `./spotlight-dev-ignore`
- Legacy wrapper: `./spotlight-dev-ignore.sh`
- Installed global command: `/usr/local/bin/spotlight-dev-ignore`
- State directory: `~/.config/spotlight-dev_v2/`
- No manual setup required

---

## Why this tool exists

Development projects often contain hundreds of thousands of generated files
that provide little value in Spotlight searches but consume CPU, disk I/O,
and indexing time.

Instead of disabling Spotlight entirely, this utility creates
`.metadata_never_index` markers only in directories that are safe to exclude.

Source code, documentation, configuration, and assets remain indexed.

---

## What v2 adds

- Dedicated state directory: `~/.config/spotlight-dev_v2/`
- Command-based CLI
- Install, update, uninstall, doctor, status, scan, adopt, undo, and clean-log commands
- Automatic creation of config, state, and log files
- Backward-compatible support for the older flag-based wrapper
- First-run adoption of existing `.metadata_never_index` markers

---

## First-run behavior

On first run, the tool automatically creates:

```text
~/.config/spotlight-dev_v2/
├── applied.txt
├── bootstrap-v2-complete
└── optimize-spotlight-dev.log
```

No manual `mkdir` or `touch` steps are required.

It also performs a one-time adoption scan for existing
`.metadata_never_index` files under these common development roots:

- `~/Documents`
- `~/Sites`
- `~/Work`

Any matching directories are imported into `applied.txt`, deduplicated, and
treated as managed by the tool. This makes `status`, `undo`, and future scans
work correctly with markers created manually or by older versions.

### Adopt existing markers

The v2 tool automatically **adopts** existing `.metadata_never_index` markers
the first time it runs.

In practice, that means it looks for marker files in:

- `~/Documents`
- `~/Sites`
- `~/Work`

For each marker it finds, the tool records the marker's parent directory in:

```text
~/.config/spotlight-dev_v2/applied.txt
```

Then it deduplicates the state file so every tracked directory appears only
once.

This is important because it makes previously unmanaged markers behave like
native v2 markers:

- `status` reports them
- `undo` can remove them
- later scans recognize them as already managed

Typical adoption sources include:

- markers created manually
- markers created by an older version of the script
- markers left behind from previous experiments

The one-time adoption pass is recorded by:

```text
~/.config/spotlight-dev_v2/bootstrap-v2-complete
```

If you add markers manually later, or want to re-import unmanaged markers after
the first run, you can use the `adopt` command.

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

## Install and usage

### Run locally from the repo

```bash
./spotlight-dev-ignore doctor
./spotlight-dev-ignore scan --dry-run ~/Documents
```

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
spotlight-dev-ignore status
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

---

## Commands

### Doctor

Validates the local environment and reports configuration issues.

```bash
spotlight-dev-ignore doctor
```

### Status

Shows current state, log, install path, and tracked directory counts.

```bash
spotlight-dev-ignore status
```

### Adopt existing markers

Imports existing `.metadata_never_index` markers into `applied.txt` without
creating new marker files.

With no arguments, it searches the same default roots used by the bootstrap:

```bash
spotlight-dev-ignore adopt
```

Preview what would be adopted:

```bash
spotlight-dev-ignore adopt --dry-run
```

Search custom roots:

```bash
spotlight-dev-ignore adopt --scan ~/Projects --scan ~/Archive
spotlight-dev-ignore adopt ~/Projects ~/Archive
```

Use this when directories were marked manually, by an older version of the
script, or outside the original first-run bootstrap.

### Scan preview

Shows what would be marked without creating any files.

```bash
spotlight-dev-ignore scan --dry-run ~/Documents ~/Sites
```

### Apply markers

Creates `.metadata_never_index` markers in matched directories.

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

Removes only markers tracked in `applied.txt`.

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

## Legacy compatibility

The older flag-based workflow still works through `./spotlight-dev-ignore.sh`:

```bash
./spotlight-dev-ignore.sh --dry-run ~/Documents
./spotlight-dev-ignore.sh --apply ~/Documents
./spotlight-dev-ignore.sh --status
./spotlight-dev-ignore.sh --undo
```

Those commands delegate to `./spotlight-dev-ignore` and use the same v2 state
directory.

---

## Files created automatically

### `applied.txt`

Tracks every directory managed by the utility.

On first run, it is also backfilled from existing `.metadata_never_index`
markers found in `~/Documents`, `~/Sites`, and `~/Work`.

You can re-import additional unmanaged markers later with:

```bash
spotlight-dev-ignore adopt
```

Used to:

- avoid duplicate work
- safely perform undo
- detect deleted projects
- adopt existing markers

### `optimize-spotlight-dev.log`

Keeps a timestamped audit trail of:

- scan roots
- bootstrap adoption activity
- directories marked
- existing markers adopted
- skipped directories
- removed state entries
- warnings
- summary statistics

### `bootstrap-v2-complete`

Marks that the one-time adoption pass has already been performed.

---

## Viewing the log

```bash
cat ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
tail -f ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
tail -100 ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
grep MARKED ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
grep BOOTSTRAP ~/.config/spotlight-dev_v2/optimize-spotlight-dev.log
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
2026-06-29 22:15:04 [BOOTSTRAP] adopted existing markers from common roots: discovered=3
2026-06-29 22:20:11 [SUMMARY] command=adopt mode=apply discovered=2 added=2 already_tracked=0
2026-06-29 22:15:04 [SCAN] /Users/[user name]/Documents
2026-06-29 22:15:04 [MARKED] /Users/[user name]/Documents/project/node_modules
2026-06-29 22:15:05 [ADOPTED] Marker already existed; adding to state
2026-06-29 22:15:05 [SKIP] Already marked and recorded
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

## Notes

- This tool is intended for macOS.
- The CLI has been tested in this workspace on macOS 11.7.11.
- Source code directories are intentionally not excluded.

---

## License

Free to modify and use for personal or commercial development workflows.
