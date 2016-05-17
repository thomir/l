# Simplify running commands inside an LXC container.


Want an easy way to run commands both inside an lxc container and on the host?
This script allows you to do that. It's not perfect though, there's some setup
required:

 * The container must be started, this script won't start it for you.
 * The container name you want to run commands in must be in a file named
   'lxc-container-name' somewhere between your current working directory and /.
   This allows you to use the same container name for a whole subsection of
   your home directory (for example a number of related bzr branches).

   If you don't have lxc containers configured in DNS, you can use the
   container IP address instead.
 * You must have SSH set up so `ssh <container_name>` does the correct thing.
   You probably also want to have your ssh key added to the container, so
   you're not prompted for a password every time you run this script.

To run a command in the container, simply do this:

  `l <command>`

for example:

  `l make test`
