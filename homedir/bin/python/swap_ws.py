#!/usr/bin/python3

import i3
import sys

WORKSPACES = i3.get_workspaces()
TEMPNAME='temporary'


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

def debug_print(json):
    import json
    pretty = json.dumps(current_ws, sort_keys=True,
                        indent=4, separators=(',', ': '))
    print(pretty)

def get_current_ws():
    return i3.filter(tree=WORKSPACES, focused=True)[0]

def ws_exists(num):
    filtered = i3.filter(tree=WORKSPACES, num=int(num))
    return len(filtered) != 0


if __name__ == "__main__":
    swap_num = check_usage(sys.argv)
    current_ws_num = str(get_current_ws()['num'])

    if (current_ws_num == swap_num):
        print("already on that number")
        sys.exit(2)

    if (ws_exists(swap_num)):
        i3.command('rename', 'workspace', swap_num, 'to', TEMPNAME)
        i3.command('rename', 'workspace', current_ws_num, 'to', swap_num)
        i3.command('rename', 'workspace', TEMPNAME, 'to', current_ws_num)
    else:
        i3.command('rename', 'workspace', current_ws_num, 'to', swap_num)
