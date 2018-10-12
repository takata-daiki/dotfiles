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
* Check in the path "$HOME/.local/share/fonts/" -> Use "DejaVu Sans Mono"
* Use [Ricty Diminished](https://github.com/mzyy94/RictyDiminished-for-Powerline/tree/master/powerline-fontpatched)

### Set the colorscheme "gruvbox"
* Prepare colorscheme in your terminal -> Check [gruvbox-contrib](https://github.com/morhetz/gruvbox-contrib) (if you use "Gnome", Check [gogh](https://github.com/Mayccoll/Gogh))
* Use vim plugin [tmuxline.vim](https://github.com/edkolev/tmuxline.vim) -> Create a snapshot -> Modify your powerline in tmux
* Run "fish_config" -> Apply gruvbox theme
