xrdb -merge $HOME/.config/X11/.Xresources
urxvtd -o -q -f
udiskie &

# Caps: tap = Escape (xcape), hold = Ctrl. caps:ctrl_modifier is also set system-wide in
# /etc/X11/xorg.conf.d/00-keyboard.conf (localectl) so it survives keyboard replug and resume.
setxkbmap -option 'caps:ctrl_modifier';xcape -e 'Caps_Lock=Escape'&
# setxkbmap -option caps:escape

exec i3
