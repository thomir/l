#!/usr/bin/python3

"""Simplify running commands inside an LXC container.

Want an easy way to run commands both inside an lxc container and on the host?
This script allows you to do that. It's not perfect though, there's some setup
required:

 * The container must be started, this script won't start it for you.
 * The container name you want to run commands in must be in a file named
   'lxc-container-name' somewhere between your current working directory and /.
   This allows you to use the same container name for a whole subsection of
   your home directory (for example a number of related bzr branches).
 * You must have SSH set up so 'ssh <container_name>' does the correct thing.
   You probably also want to have your ssh key added to the container, so
   you're not prompted for a password every time you run this script.

To run a command in the container, simply do this:

  $ l <command>

for example:

  $ l make test
"""

import os
import subprocess
import sys


def main():
    container_name = get_lxc_container_name_or_raise()
    if len(sys.argv) < 2:
        print("Missing command to run!")
    arguments = [
        'ssh', '-t', container_name,
        'cd %s && TERM=screen %s' % (os.getcwd(), ' '.join(sys.argv[1:]))
    ]
    print("Running: %r" % arguments)
    sys.exit(subprocess.call(arguments))


def get_lxc_container_name_or_raise():
    start_dir = os.getcwd()
    searched_paths = [start_dir]
    while True:
        conf_file = os.path.join(start_dir, 'lxc-container-name')
        if os.path.exists(conf_file):
            return open(conf_file, 'rt').read().strip()
        if start_dir == '/':
            raise RuntimeError(
                "Could not find 'lxc-container-name' file. Paths searched are:"
                "%s" % ', '.join(searched_paths))
        start_dir = os.path.dirname(start_dir)


if __name__ == '__main__':
    main()
