# Completions for the claude function

# Our custom tracing flags
complete -c claude -s T -l with-tracing -d "Enable request tracing via claude-trace"

# Claude Trace specific options (only show when tracing is enabled)
complete -c claude -l extract-token -d "Extract OAuth token and exit" -n "__fish_seen_subcommand_from -T --with-tracing; or __claude_has_trace_args"
complete -c claude -l generate-html -d "Generate HTML report from JSONL file" -n "__fish_seen_subcommand_from -T --with-tracing; or __claude_has_trace_args"
complete -c claude -l index -d "Generate conversation summaries and index" -n "__fish_seen_subcommand_from -T --with-tracing; or __claude_has_trace_args"
complete -c claude -l include-all-requests -d "Include all requests made through fetch" -n "__fish_seen_subcommand_from -T --with-tracing; or __claude_has_trace_args"
complete -c claude -l no-open -d "Don't open generated HTML file in browser" -n "__fish_seen_subcommand_from -T --with-tracing; or __claude_has_trace_args"

# Helper function to detect if trace-specific args are present
function __claude_has_trace_args
    string match -q "*--extract-token*" -- (commandline -c)
    or string match -q "*--generate-html*" -- (commandline -c)
    or string match -q "*--index*" -- (commandline -c)
    or string match -q "*--include-all-requests*" -- (commandline -c)
    or string match -q "*--no-open*" -- (commandline -c)
end

# Helper function to detect if we're in trace mode
function __claude_in_trace_mode
    __fish_seen_subcommand_from -T --with-tracing
    or __claude_has_trace_args
end

# Claude Code options (show unless we're purely in trace mode with trace-only args)
complete -c claude -s d -l debug -d "Enable debug mode"
complete -c claude -l verbose -d "Override verbose mode setting from config"
complete -c claude -s p -l print -d "Print response and exit (useful for pipes)"
complete -c claude -l output-format -d "Output format (text, json, stream-json)" -xa "text json stream-json"
complete -c claude -l input-format -d "Input format (text, stream-json)" -xa "text stream-json"
complete -c claude -l mcp-debug -d "Enable MCP debug mode"
complete -c claude -l dangerously-skip-permissions -d "Bypass all permission checks"
complete -c claude -l allowedtools -d "Comma or space-separated list of tool names to allow"
complete -c claude -l disallowedtools -d "Comma or space-separated list of tool names to deny"
complete -c claude -l mcp-config -d "Load MCP servers from a JSON file or string"
complete -c claude -s c -l continue -d "Continue the most recent conversation"
complete -c claude -s r -l resume -d "Resume a conversation" -xa "(__claude_list_sessions)"
complete -c claude -l model -d "Model for the initial context" -xa "sonnet opus claude-sonnet-4-20250514"
complete -c claude -l fallback-model -d "Enable automatic fallback to specified model"
complete -c claude -l add-dir -d "Additional directories to allow tool access to"
complete -c claude -l ide -d "Automatically connect to IDE on startup"
complete -c claude -s v -l version -d "Output the version number"
complete -c claude -s h -l help -d "Display help for command"

# Helper function to list available sessions (if implemented)
function __claude_list_sessions
    # This would need to be implemented based on how Claude Code stores sessions
    # For now, just return empty
    return 1
end

# File completions for generate-html
complete -c claude -l generate-html -F -d "JSONL file to generate HTML from"
