# Claude Fish Integration
# Unified wrapper for Claude Code and Claude Trace with intelligent routing
#
# This function provides a single 'claude' command that automatically routes
# between claude and claude-trace based on the arguments provided.
#
# Usage modes:
#   claude "prompt"                    -> claude code "prompt"
#   claude -T "prompt"                 -> claude-trace --run-with "prompt"  
#   claude --extract-token             -> claude-trace --extract-token
#   claude -T --include-all-requests "prompt" -> claude-trace --include-all-requests --run-with "prompt"
#
# The function detects trace mode via:
#   1. Explicit flags: -T, --with-tracing
#   2. Claude Trace-specific options: --extract-token, --generate-html, etc.
#
function claude
    set -l use_trace false
    set -l claude_args
    set -l trace_args
    set -l has_help false

    # Define Claude Trace specific options that automatically enable trace mode
    set -l trace_options --extract-token --generate-html --index --include-all-requests --no-open

    # Parse arguments to separate trace flags, trace options, and claude arguments
    # Logic: 
    #   - Custom flags (-T, --with-tracing) enable trace mode
    #   - Claude Trace options (--extract-token, etc.) enable trace mode AND go to trace_args
    #   - Everything else goes to claude_args (including --help)
    for arg in $argv
        switch "$arg"
            case --with-tracing -T
                set use_trace true
            case --help -h
                set has_help true
                set claude_args $claude_args $arg
            case --extract-token --generate-html --index --include-all-requests --no-open
                # Claude Trace specific options - enable trace mode and collect for trace_args
                set trace_args $trace_args $arg
                set use_trace true
            case "*"
                # Everything else goes to Claude Code arguments (models, prompts, etc.)
                set claude_args $claude_args $arg
        end
    end

    # Handle help requests contextually
    # - If trace mode is active (via flags or trace options), show claude-trace help
    # - Otherwise, show claude help plus our custom tracing option documentation
    if test "$has_help" = true
        if test "$use_trace" = true
            command claude-trace --help
        else
            command claude --help
            echo ""
            echo "Additional options:"
            echo "  -T, --with-tracing              Enable request tracing via claude-trace"
            echo ""
            echo "Note: When --with-tracing is used, claude-trace options are also available."
            echo "Use 'claude -T --help' to see claude-trace specific options."
        end
        return
    end

    # Execute the appropriate command based on detected mode and arguments
    # 
    # Trace mode routing:
    #   1. Both trace_args + claude_args: claude-trace <trace-options> --run-with <claude-args>
    #   2. Only trace_args: claude-trace <trace-options> (standalone features like --extract-token)
    #   3. Only claude_args with trace flag: claude-trace --run-with <claude-args>
    #
    # Normal mode:
    #   4. claude <claude-args>
    #
    # Note: Using 'command' prefix to call actual binaries, not this function recursively
    if test "$use_trace" = true
        if test (count $claude_args) -gt 0 -a (count $trace_args) -gt 0
            # Both trace options and claude arguments
            # Example: claude -T --include-all-requests --model sonnet "fix this"
            # Becomes: claude-trace --include-all-requests --run-with --model sonnet "fix this"
            command claude-trace $trace_args --run-with $claude_args
        else if test (count $trace_args) -gt 0
            # Only trace options (standalone Claude Trace features)
            # Example: claude --extract-token
            # Becomes: claude-trace --extract-token
            command claude-trace $trace_args
        else
            # Only claude arguments with tracing enabled
            # Example: claude -T --model sonnet "fix this"
            # Becomes: claude-trace --run-with --model sonnet "fix this"
            command claude-trace --run-with $claude_args
        end
    else
        # Normal Claude Code execution
        # Example: claude --model sonnet "fix this"
        # Becomes: claude --model sonnet "fix this"
        command claude $claude_args
    end
end
