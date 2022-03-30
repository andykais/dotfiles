#!/usr/bin/python3

from i3ipc import Connection, Event
import sys


TEMPNAME='temporary'


i3 = Connection()


def check_usage(args):
    if len(args) != 2:
        print("usage: swap_ws.py [ window# ]")
        sys.exit(2)

    try:
        int(args[1])
    except TypeError:
        print("usage: swap_ws.py [ window# ]")
        sys.exit(2)

    return args[1]


def ws_exists(num):
    return i3.get_tree().find_named(num) is not None



if __name__ == "__main__":
    swap_num = check_usage(sys.argv)

    current_ws = i3.get_tree().find_focused()
    # current_ws_num = str(get_current_ws()['num'])
    current_ws_num = str(current_ws.workspace().num)
    print('current_ws_num', current_ws_num)
    print('swap_num', swap_num)
    print('ws_exists(swap_num)', ws_exists(swap_num))

    if (current_ws_num == swap_num):
        print("already on that number")
        sys.exit(2)

    if (ws_exists(swap_num)):
        i3.command(f"rename workspace {swap_num} to {TEMPNAME}")
        i3.command(f"rename workspace {current_ws_num} to {swap_num}")
        i3.command(f"rename workspace {TEMPNAME} to {current_ws_num}")
    else:
        i3.command(f"rename workspace {current_ws_num} to {swap_num}")
