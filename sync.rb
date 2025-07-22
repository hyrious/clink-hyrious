# 1. This file can't be lua or it will be loaded by clink.
# 2. The script should have access to the network and file system.

require "open-uri"

# Setup 'z' command.
code = URI.open('https://raw.gitmirror.com/shunsambongi/clink-zoxide/refs/heads/master/zoxide.lua', &:read)
IO.write 'zoxide.lua', code

# Setup vscode shell integration.
code = URI.open('https://raw.gitmirror.com/chrisant996/clink-gizmos/refs/heads/main/vscode_shell_integration.lua', &:read)
IO.write 'vscode_shell_integration.lua', code
