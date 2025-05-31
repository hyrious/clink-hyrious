
os.setalias('el', 'eza -lA --no-quotes $*')
os.setalias('md', 'bun x @hyrious/marked-cli')
os.setalias('sp', 'bun x @hyrious/sort-package-json')
os.setalias('sm', 'smerge .')

-- Press Ctrl+K to clear the display (ignore scroll buffer).
function cls_and_return(rl_buffer)
  rl_buffer:setcursor(1)
  rl.invokecommand("kill-line")
  rl_buffer:insert("cls")
  rl.invokecommand("accept-line")
end
if rl.describemacro then
  rl.describemacro(
    "luafunc:cls_and_return",
    "Clear the display like typing 'cls' and return")
end
if rl.getbinding then
  -- Originally 'kill-line'.
  rl.setbinding([["\C-K"]], [["luafunc:cls_and_return"]])
end
