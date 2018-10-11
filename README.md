# Dotfiles

The installation step in OS X requires the [XCode Command Line Tools](https://developer.apple.com/downloads)

```
$ java -v
$ xcode-select --install
```

Run the following command:

```
$ bash -c "$(curl -fsSL raw.github.com/takata-daiki/dotfiles/master/install.sh)"
```

### Custom Configuration:

##### Set the colorscheme "gruvbox"
* Prepare colorscheme in your terminal -> Check [gruvbox-contrib](https://github.com/morhetz/gruvbox-contrib) (if you use "Gnome", Check [gogh](https://github.com/Mayccoll/Gogh))
* Use vim plugin "tmuxline.vim" -> Create a snapshot -> Modify your powerline in tmux
* Run "fish_config" -> Apply your favorite theme
