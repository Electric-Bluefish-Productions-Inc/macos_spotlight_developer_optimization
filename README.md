# Spotlight Dev Ignore

A macOS utility for developers that reduces Spotlight indexing overhead
by selectively excluding dependency, cache, build, and generated
directories while leaving source code searchable.

## Why this tool exists

Development projects often contain hundreds of thousands of generated
files that provide little value in Spotlight searches but consume CPU,
disk I/O, and indexing time.

Instead of disabling Spotlight entirely, this tool creates
`.metadata_never_index` markers in directories that are safe to exclude.

Source code, documentation, project configuration, and assets remain
indexed.

------------------------------------------------------------------------

# Supported Technologies

-   JavaScript / Node.js
-   PHP / Composer
-   Laravel
-   WordPress
-   Joomla
-   Python

## Automatically excluded

### General

-   node_modules
-   vendor
-   .venv / venv / env
-   **pycache**
-   .tox
-   .nox
-   .pytest_cache
-   .mypy_cache
-   .ruff_cache
-   coverage
-   htmlcov
-   build
-   dist
-   .next
-   .nuxt
-   .parcel-cache
-   .turbo
-   .cache
-   .vite
-   bower_components
-   .gradle

### Laravel

-   bootstrap/cache
-   storage/framework/cache
-   storage/framework/views
-   storage/framework/sessions
-   storage/framework/testing
-   storage/logs

------------------------------------------------------------------------

# Features

-   Dry-run mode
-   Apply mode
-   Undo mode
-   Status reporting
-   Automatic adoption of existing `.metadata_never_index` markers
-   Persistent state database
-   Timestamped audit log
-   Automatic cleanup of stale state entries
-   Multiple scan roots
-   Optional Spotlight daemon restart
-   Safe to run repeatedly (idempotent)

------------------------------------------------------------------------

# Files Created

    ~/.config/spotlight-dev-ignore/
    ├── applied.txt
    └── optimize-spotlight-dev.log

## applied.txt

Tracks every directory managed by the utility.

Used to:

-   avoid duplicate work
-   safely perform undo
-   detect deleted projects
-   adopt existing markers

## optimize-spotlight-dev.log

Records:

-   scan roots
-   directories marked
-   existing markers adopted
-   skipped directories
-   removed state entries
-   warnings
-   summary statistics

------------------------------------------------------------------------

# Viewing the Log

Display the log:

``` bash
cat ~/.config/spotlight-dev-ignore/optimize-spotlight-dev.log
```

Follow live:

``` bash
tail -f ~/.config/spotlight-dev-ignore/optimize-spotlight-dev.log
```

Show the last 100 lines:

``` bash
tail -100 ~/.config/spotlight-dev-ignore/optimize-spotlight-dev.log
```

Search for marked directories:

``` bash
grep MARKED ~/.config/spotlight-dev-ignore/optimize-spotlight-dev.log
```

Search for warnings:

``` bash
grep WARN ~/.config/spotlight-dev-ignore/optimize-spotlight-dev.log
```

------------------------------------------------------------------------

# Viewing the State Database

``` bash
cat ~/.config/spotlight-dev-ignore/applied.txt
```

Count managed directories:

``` bash
wc -l ~/.config/spotlight-dev-ignore/applied.txt
```

------------------------------------------------------------------------

# Usage

## Preview changes

``` bash
spotlight-dev-ignore --dry-run ~/Documents
```

Multiple roots:

``` bash
spotlight-dev-ignore --dry-run ~/Documents ~/Sites ~/Work ~/Scripts
```

## Apply changes

``` bash
spotlight-dev-ignore --apply ~/Documents ~/Sites ~/Work
```

Restart Spotlight afterwards:

``` bash
spotlight-dev-ignore --apply ~/Documents --restart-mds
```

Verbose output:

``` bash
spotlight-dev-ignore --apply ~/Documents --verbose
```

## Status

``` bash
spotlight-dev-ignore --status
```

## Undo

``` bash
spotlight-dev-ignore --undo
```

## Clean the audit log

``` bash
spotlight-dev-ignore --clean-log
```

## Custom scan root

``` bash
spotlight-dev-ignore --scan /Volumes/DevelopmentSSD
```

Multiple custom roots:

``` bash
spotlight-dev-ignore --scan ~/Documents --scan ~/Sites --scan ~/Work
```

------------------------------------------------------------------------

# Example Log

``` text
2026-06-29 22:15:04 [SCAN] /Users/james/Documents
2026-06-29 22:15:04 [MARKED] /Users/james/Documents/project/node_modules
2026-06-29 22:15:05 [ADOPTED] Existing marker added to state
2026-06-29 22:15:05 [SKIP] Already managed
2026-06-29 22:15:06 [MISSING] Deleted project removed from state
2026-06-29 22:15:07 [SUMMARY] 18 marked, 214 already managed
```

------------------------------------------------------------------------

# Best Practices

-   Run after cloning new repositories.
-   Run periodically as projects evolve.
-   Review with `--dry-run` before large scans.
-   Keep the log for auditing.
-   Do not place `.metadata_never_index` in source directories.

------------------------------------------------------------------------

# License

Free to modify and use for personal or commercial development workflows.
# macos_spotlight_developer_optimization
