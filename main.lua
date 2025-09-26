os.setenv('NI_DEFAULT_AGENT', 'bun') -- Bun runs faster

-- $* will be expaneded to rest args
os.setalias('el', 'eza -lA --no-quotes $*')
os.setalias('ed', 'esbuild-dev $*')
os.setalias('md', 'bun x @hyrious/marked-cli $*')
os.setalias('sp', 'bun x @hyrious/sort-package-json')
os.setalias('sm', 'smerge .')
os.setalias('smm', 'git branch -f main origin/main')
os.setalias('nrb', 'nr --if-present build $*')
os.setalias('bunx', 'bun x $*')
os.setalias('proxy', 'set https_proxy=http://127.0.0.1:7890&& set http_proxy=http://127.0.0.1:7890&& set all_proxy=socks5://127.0.0.1:7890')
os.setalias('noproxy', 'set https_proxy=&& set http_proxy=&& set all_proxy=')
os.setalias('open', 'start "" $*')
os.setalias('nb', 'start "" "https://hyrious.me/npm-browser/?q=$*"')
os.setalias('unpkg', 'start "" "https://unpkg.shop.jd.com/$*"')
-- https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
os.setalias('gl', 'git pull $*')
os.setalias('gfa', 'git fetch --all --tags --prune --jobs=10')
os.setalias('gbm', 'git branch --move $*')
os.setalias('gsw', 'git switch $*')
os.setalias('gswc', 'git switch --create $*')
os.setalias('grhh', 'git reset --hard $*')
os.setalias('gwip', 'git add -A && git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"')
os.setalias('gpsup', 'git push --set-upstream origin $(git_current_branch)')

-- Replace '$(git_current_branch)' with the real value.
local function resolve_git_current_branch(line)
  if line == 'gpsup' then line = os.resolvealias(line)[1] end
  local i = 1
  local result = ''
  local continue
  local var = '$(git_current_branch)'
  local value
  local first = true
  while true do
    local s = line:find(var, i, true)
    if not s then
      result = result..line:sub(i)
      break
    end
    result = result..line:sub(i, s - 1)
    i = s + #var
    continue = false
    -- https://github.com/chrisant996/clink-flex-prompt/blob/master/flexprompt.lua
    if first then
      value = flexprompt.get_git_branch()
      first = false
    end
    if value then
      result = result..value
    end
  end
  return result, continue
end

clink.onfilterinput(resolve_git_current_branch)

-- Write '$env:key = expr' to capture stdout of expr.
local function exec(str)
  local raw
  local f = io.popen(str)
  if f then
    raw = f:read("*a")
    while true do
      local t = raw:sub(#raw)
      if t ~= '\r' or t ~= '\n' then break end
      raw = raw:sub(1, #raw - 1)
    end
    f:close()
  end
  return (raw ~= '') and raw or nil
end

local function setenv_shortcut(line)
  local key, expr = line:match("^%s*%$env:(%S+)%s*=%s*(.*)$")
  if key and key ~= '' and expr and expr ~= '' then
    local value = exec(expr)
    if value then
      print(key .. " = " .. value)
    else
      print(key .. " = nil")
    end
    os.setenv(key, value)
    return ''
  end
  return nil
end

clink.onfilterinput(setenv_shortcut)

local setenv_classifier = clink.classifier(50)
function setenv_classifier:classify(commands)
  if not commands[1] then return end

  local color = settings.get('color.doskey')
  if not color or color == '' then return end

  local color_key = settings.get('color.cmd')
  local color_equal = settings.get('color.suggestion')

  local line_state = commands[1].line_state
  local classifications = commands[1].classifications
  local line = line_state:getline()

  if line:match("^%s*%$env:") then
    local start = line:find("%$env:")
    classifications:applycolor(start, 5, color, true)

    local key = line:find("[%s=]")
    if key then
      classifications:applycolor(start + 5, key - start - 5, color_key, true)

      local equal = line:find("=", key)
      if equal then
        classifications:applycolor(equal, 1, color_equal, true)
      end
    end
  end
end

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
