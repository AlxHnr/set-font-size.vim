# set-font-size.vim

This plugin allows you to resize the terminal font on the fly. At the
moment only [rxvt-unicode](http://software.schmorp.de/pkg/rxvt-unicode) is
supported, and only if you have defined a xft font with a specified size in
your _~/.Xresources_.

The plugin defines just one command: **SetFontSize**. Here are some usage
examples:

```vim
" Set the fontsize to 12:
SetFontSize 12

" Increase the fontsize by 3:
SetFontSize +3

" Decrease the fontsize by 2:
SetFontSize -2

" Reset the fontsize:
SetFontSize
```

## License

Released under the zlib license.
