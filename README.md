<div align="center">

# 📦 Termux Safe Bootstrap

**A transparent, opt-in starter for a useful Termux development environment.**

![Termux](https://img.shields.io/badge/Termux-111111?style=flat-square&logo=terminal&logoColor=white)
![No root](https://img.shields.io/badge/Root-not%20required-3DDC84?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-777777?style=flat-square)

</div>

A small Bash helper that checks for core developer tools and can install a conservative set of packages through Termux's own `pkg` command.

## Install and run

```bash
git clone https://github.com/Gass-OS/termux-safe-bootstrap.git
cd termux-safe-bootstrap
bash bootstrap.sh --dry-run
bash bootstrap.sh
```

The default package set is `git`, `curl`, `wget`, `nano`, `openssh`, `python`, and `file`.

## Options

```bash
bash bootstrap.sh --dry-run
bash bootstrap.sh --packages "git python clang"
bash bootstrap.sh --help
```

- `--dry-run`: show the command without running it.
- `--packages`: explicitly choose package names (space-separated).
- `--help`: show usage.

## Safety model

- No root or `sudo`.
- No shell commands downloaded from the internet.
- No automatic edits to shell startup files.
- Uses Termux's `pkg install` and asks before installing.
- Review custom package names before confirming.

## License

MIT. See [`LICENSE`](LICENSE).
