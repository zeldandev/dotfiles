
## Set up NEOVIM

1. Backup any existing config you have:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. Delete your local nvim cache:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
```

3. Run nvim and not install example config:

```bash
nvim
```

Useful command inside nvchad:
- <SPC> t h -- change theme (catppuccine)
- :TSinstallInfo -- check which syntax highlight are install
- ctr + n -- open nvimtree
  - a -- create new file
  - c -- copy file
  - p -- paste a file
  - r -- rename file
- <SPC> f f -- find file
- <SPC> f b -- find a open buffer
  - tab -- cycle between open buffers
  - shift + tab -- counter cycle between open buffers
  - <SPC> x -- close active buffer
- <SPC> c h -- cheatSheet
- ctr + h / ctr + j / ctr +k / ctr + l -- move around windows
- sp -- horizontal split
- vsp -- vertical split
- <SPC> n -- toggle line numbers
- <SPC> r n -- toggle relative line numbers
- <SPC> h -- open nvim terminal (horizontal)
- <SPC> v -- open nvim terminal (vertical)


to add custom configurations you should edit following files
- ~/.config/nvim/lua/custom/chadrc.lua -- override default nvichad config
- ~/.config/nvim/lua/custom/init.lua -- override default neovim config

### Plugins:
Pluggin manager is `Lazy` to install new plugins after add in config files execute command `:Lazy sync`
- treesitter: 
- lsp: lenguage server 
