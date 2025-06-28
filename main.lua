-- $* will be expaneded to rest args
os.setalias('el', 'eza -lA --no-quotes $*')
os.setalias('md', 'bun x @hyrious/marked-cli $*')
os.setalias('sp', 'bun x @hyrious/sort-package-json')
os.setalias('sm', 'smerge .')
os.setalias('smm', 'git branch -f main origin/main') -- Sync 'main' to 'origin/main'
os.setenv('NI_DEFAULT_AGENT', 'bun') -- Bun runs faster
os.setalias('nrb', 'nr build $*')
os.setalias('bunx', 'bun x $*')
-- https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
os.setalias('gl', 'git pull $*')
os.setalias('gfa', 'git fetch --all --tags --prune --jobs=10')
os.setalias('gbm', 'git branch --move $*')
os.setalias('grhh', 'git reset --hard $*')
os.setalias('gpsup', 'git push --set-upstream origin $(git_current_branch)')

-- Replace '$(git_current_branch)' with the real value.
-- https://github.com/chrisant996/clink-gizmos/blob/main/command_substitution.lua
local function git_current_branch()
  local raw
  local f = io.popen("git branch --show-current 2>nul")
  if f then
    raw = f:read("*a")
    while true do
      local t = raw:sub(#raw)
      if t ~= '\r' or t ~= '\n' then break end
      raw = raw:sub(1, #raw - 1)
    end
    f:close()
  end
  return raw or '""'
end

local function resolve_git_current_branch(line)
  if line == 'gpsup' then line = os.resolvealias(line)[1] end
  local i = 1
  local result = ''
  local continue
  local var = '$(git_current_branch)'
  local value
  while true do
    local s = line:find(var, i, true)
    if not s then
      result = result..line:sub(i)
      break
    end
    result = result..line:sub(i, s - 1)
    i = s + #var
    continue = false
    value = value or git_current_branch()
    if value then
      result = result..value
    end
  end
  return result, continue
end

clink.onfilterinput(resolve_git_current_branch)

-- Press Ctrl+K to clear the display (clear all scroll buffer).
-- It seems simple 'clear-display' does not clear all scroll buffer.
function cls_and_return(rl_buffer)
  rl_buffer:setcursor(1)
  rl.invokecommand("kill-line")
  rl_buffer:insert("cls")
  rl.invokecommand("accept-line")
end

rl.describemacro(
  "luafunc:cls_and_return",
  "Clear the display like typing 'cls' and return")

-- Originally 'kill-line'.
rl.setbinding([["\C-K"]], [["luafunc:cls_and_return"]])
