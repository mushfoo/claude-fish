# Claude Fish Integration

A Fish shell wrapper that provides seamless integration between [Claude Code](https://github.com/anthropics/claude-code) and [Claude Trace](https://github.com/mariozechner/claude-trace), with intelligent command routing and rich autocomplete support.

## What it does

This creates a unified `claude` command that intelligently routes between Claude Code and Claude Trace based on the arguments you provide, while preserving all functionality of both tools.

**Key Features:**

- 🎯 **Smart routing** - automatically detects when to use Claude Trace vs Claude Code
- 🚀 **Unified interface** - one command to rule them all
- 📖 **Context-aware help** - shows relevant help for the current mode
- ✨ **Rich autocomplete** - comprehensive tab completion with descriptions
- 🔄 **Full compatibility** - all original arguments and options work unchanged

## Installation

### Prerequisites

- [Fish Shell](https://fishshell.com/)
- [Claude Code](https://github.com/anthropics/claude-code) (globally installed)
- [Claude Trace](https://github.com/mariozechner/claude-trace) (globally installed)

```bash
# Install Claude Code globally
npm install -g @anthropics/claude-code

# Install Claude Trace globally
npm install -g @mariozechner/claude-trace
```

### Install the Fish integration

```bash
# Clone this repository
git clone https://github.com/yourusername/claude-fish.git
cd claude-fish

# Copy the function file
cp functions/claude.fish ~/.config/fish/functions/

# Copy the completions file
cp completions/claude.fish ~/.config/fish/completions/

# Reload Fish configuration (or start a new shell session)
source ~/.config/fish/config.fish
```

## Usage

### Regular Claude Code usage

```bash
claude "fix this bug"
claude --model sonnet "help me with this code"
claude --print "explain this function"
```

### Claude Code with tracing enabled

```bash
claude -T "fix this bug"
claude --with-tracing --model sonnet "debug this issue"
```

### Claude Trace standalone features

```bash
claude --extract-token
claude --generate-html logs/traffic.jsonl report.html
claude --index
claude --generate-html logs/file.jsonl --no-open
```

### Combined usage (trace options + claude arguments)

```bash
claude -T --include-all-requests --model sonnet "fix this code"
claude --generate-html logs/file.jsonl --model opus "analyze patterns"
```

### Help system

```bash
claude --help              # Shows Claude Code help + tracing options
claude -T --help           # Shows Claude Trace help
claude --extract-token --help  # Shows Claude Trace help
```

## How it works

The wrapper intelligently determines which tool to use based on:

1. **Explicit tracing flag**: `-T` or `--with-tracing`
2. **Claude Trace-specific options**: `--extract-token`, `--generate-html`, `--index`, `--include-all-requests`, `--no-open`

When tracing is detected, it routes to `claude-trace` with appropriate `--run-with` arguments. Otherwise, it uses `claude` directly.

## Command Mapping

| Your Input                                | Actual Command                                          |
| ----------------------------------------- | ------------------------------------------------------- |
| `claude "help"`                           | `claude "help"`                                         |
| `claude -T "help"`                        | `claude-trace --run-with "help"`                        |
| `claude --extract-token`                  | `claude-trace --extract-token`                          |
| `claude -T --include-all-requests "help"` | `claude-trace --include-all-requests --run-with "help"` |

## Autocomplete Features

Rich tab completion includes:

- All Claude Code options and arguments
- All Claude Trace options (contextually shown)
- Value suggestions for options like `--model` and `--output-format`
- File completion for paths
- Helpful descriptions for all options

Try pressing `Tab` after typing `claude` to explore available options!

## Acknowledgements

This project builds upon the excellent work of:

- **[Claude Code](https://github.com/anthropics/claude-code)**
- **[Claude Trace](https://github.com/mariozechner/claude-trace)**

Special thanks to the Fish shell community for creating such an elegant and extensible shell environment that makes tools like this possible.

## License

MIT License - see [LICENSE](LICENSE) for details.
