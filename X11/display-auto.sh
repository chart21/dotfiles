#!/bin/sh
# Enable every connected output at its largest mode and highest refresh rate, turn off disconnected ones.
# With no monitor connected, keep a 1920x1080 framebuffer: X would otherwise shrink it to its 8x8 minimum and
# x0vncserver would serve that to the laptop. x0vncserver has no RANDR support and never follows a resize, so
# it is restarted after every change.
# Usage: display-auto.sh          apply once
#        display-auto.sh --watch  apply, then re-apply whenever the set of connected outputs changes
connected() { xrandr --query | awk '/^[A-Za-z0-9-]+ connected/ {print $1}'; }
apply() {
    xrandr --query | awk '
        /^[A-Za-z0-9-]+ (dis)?connected/ { cur=""; if ($2=="connected") { cur=$1; order[++n]=cur; mode[cur]="" } else off[$1]=1; next }
        cur != "" && /^ +[0-9]+x[0-9]+/ && mode[cur]=="" {
            mode[cur]=$1
            for (i=2;i<=NF;i++) { r=$i; gsub(/[*+]/,"",r); if (r+0 > rate[cur]+0) rate[cur]=r }
        }
        END {
            printf "xrandr"
            for (o in off) printf " --output %s --off", o
            pos=0
            for (i=1;i<=n;i++) {
                o=order[i]
                printf " --output %s --mode %s --rate %s --pos %dx0 --rotate normal%s", o, mode[o], rate[o], pos, (i==1 ? " --primary" : "")
                split(mode[o], d, "x"); pos += d[1]
            }
            if (n == 0) printf " --fb 1920x1080"
            print ""
        }' | sh
    case "$DISPLAY" in :0*)  # only :0 is mirrored by x0vncserver; an i3 on the VNC desktop :1 must not touch it
        XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
            systemctl --user restart x0vncserver >/dev/null 2>&1 || true ;;
    esac
}
apply
if [ "$1" = "--watch" ]; then
    last=$(connected)
    while sleep 3; do
        now=$(connected)
        [ "$now" != "$last" ] && { apply; last=$now; }
    done
fi
