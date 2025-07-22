# My Clink Profile

Personal [Clink](https://github.com/chrisant996/clink) setup.

## Install

```bat
❯ winget install chrisant996.Clink
❯ scoop install clink-flex-prompt
❯ clink installscripts ~\scoop\apps\clink-flex-prompt\current
❯ winget install ajeetdsouza.zoxide
❯ git clone <this-repo>
❯ clink installscripts path\to\this\repo
```

Press `Ctrl+X, Ctrl+R` to reload scripts without restart the shell.

## `flexprompt_config.lua`

```lua
flexprompt.settings.left_prompt = "{histlabel}{cwd}{git}{duration}{time:format=}"
flexprompt.settings.symbols = { prompt = {"❯"} }
```

## License

MIT @ [hyrious](https://github.com/hyrious)
