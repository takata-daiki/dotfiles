# Dotfiles

## Usage

The installation step in OS X requires the [XCode Command Line Tools](https://developer.apple.com/downloads).

```
$ java -v
$ xcode-select --install
```

Run the following command:

```
$ bash -c "$(curl -fsSL raw.github.com/takata-daiki/dotfiles/master/install.sh)"
```

## Configuration

### Set powerline patched fonts
* Check the default font used by SpacevVim [SauceCodePro](https://spacevim.org/documentation/#font)

### Set the colorscheme "gruvbox"
* Check [gruvbox-contrib](https://github.com/morhetz/gruvbox-contrib) to prepare colorscheme in your terminal ([gogh](https://github.com/Mayccoll/Gogh) if you use "Gnome")
* Use vim plugin [tmuxline.vim](https://github.com/edkolev/tmuxline.vim) and create a snapshot of powerline for tmux
* Run `fish_config` and apply gruvbox theme
