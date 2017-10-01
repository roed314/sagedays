# sagedays

Tools for running a Sage Days workshop on CoCalc

## Installation

 * Create a new project, either on the public CoCalc instances or on another server running CoCalc
 * Open the project, and in the `terminal command` line run `git clone https://github.com/roed314/sagedays.git .sagedays`
 * In the same command line, run `mv .sagedays/* .sagedays/.sd.setup .`
 * Open up the terminal `Terms/Admin.term` and run `~/.sd.setup`

## Structure

The installation will create four top level folders and one symlink.

 * `bin` contains scripts and is in the path.
 * `Src` contains source code, including Sage installations.
 * `Terms` contains terminals for users.
 * `user` contains users' home directories.  By default, these contain `.bashrc` and dependencies, as well as a `.gitconfig`, but of course users can use them in other ways.
 * `authorized_keys` is a symlink to the corresponding file in the `.ssh` folder, which should be modified to allow ssh access to the project by users.

You may also want to create a `Talks` folder for participants to put material for talks they're giving.

## Scripts

These scripts are mostly in the `bin` folder and can be run from any location.

### .sd.setup

This is the only script not contained in the `bin` folder, and is only used for installation.  It **must be copied to the main directory before execution**, and performs the following tasks:

 * Prompts for the number of the Sage Days and stores it in a file.
 * Modifies the global `.bashrc` file to set `LANG` and `PATH`.
 * Creates a symlink to the authorized keys file.
 * Downloads the `git-trac` command and creates a symlink to it in `bin`.
 * Downloads the `git-completion` bash file for tab completion of branches.
 * Downloads the `binary-pkg` project and uses it to build a binary copy of Sage that can be copied, which is stored in `Src/sage-latest.tar`.

### setup_user

The goal of this script is to set up the environment for a new user. It has two modes.  If you provide it with a text file as a command line argument, it will parse it and create users accordingly.  If you provide no arguments, it will ask questions interactively of the new user.

Each line of the text file should consist of comma separated values: `trac username`, `full name`, `email`, optional `password`.  If there is already a home directory for a given user, they will be skipped.

The script performs the following tasks:

 * Creates a home directory by copying the `template`.
 * Configures `git` and `git-trac` by setting the name, e-mail, trac username (and optionally trac password) in the `.gitconfig` file in the home directory.
 * Creates an ssh key for the user which can be uploaded to trac.
 * Creates a terminal for the user and creates an initialization script to run on startup.
 * Adds lines for a preferred editor to `.bashrc` (interactive mode only) and an alias for `sage` to `.bash_aliases`.

### new_sage

This script creates a new copy of `sage` .  You can either pass in names at the command line, or it will use your trac username if you use it from your own terminal.  It performs the following tasks

 * Extracts `sage` from the `sage-latest.tar` tarball and renames it
 * Sets `git remote` correctly on the new install to use trac.
 * Runs the `relocate-once.py` script and `make` (in parallel) so that the new sage is usable for development.

### refresh_sage_tarball

This script updates the `sage-latest.tar` to the most recent beta of Sage.  It will take some time to run, since it has to build Sage from scratch.

### .init_user

This script is run when a user opens their terminal or `ssh`s into the project.  It take the trac username as an argument, and performs the following tasks:

 * Sets the `$USER` variable to the trac username
 * Sets the `$MAIN` variable to the top level folder
 * Sets the `$HOME` variable to `$HOME/user/$USER`, the user's home directory
 * Sets the `$SDNUM` variable to the number of the Sage days
 * Starts `bash`, or whatever command was being executed over `ssh`.

Without the `-q` option, it will also print this information.

### set_trac_password

This script can be run by a user to store their trac password in the appropriate file.

### unset_trac_password

This script can be run by a user to delete their trac password and instead prompt for it when a terminal is opened.

### show_ssh_key

This script can be run by a user to print their ssh key, to be uploaded to https://trac.sagemath.org/prefs/sshkeys.

### set_editor

This script can be run by a user to set the editor used for `git` commits.

## User documentation

This documentation can be placed on the Sage Days wiki page for users.  You'll probably want to edit the values `NNN` (Sage Days number), `ORGANIZER` (organizer name) and `XXX` (project username with hyphens removed) appropriately.  If you need the secret token for account creation, e-mail William Stein (wstein@sagemath.com) or David Roe (roed.math@gmail.com).

```
== The k8s server ==

William Stein has kindly provided a server for us to use during the workshop, with 48 CPUs and 256 GB of RAM.  It is running !CoCalc, so you can access it from your browser.

=== Creating an Account ===

You should create an account [[https://k8s.sagemath.org/settings|here]].  You will need a secret token, which will be e-mailed to participants (ask an organizer if you can't find it).  Once you have an account, someone will have to add you to the Sage Days NNN project; anyone who is already part of the project can do so from the project settings page.  At that point, you will be able to access the server at [[https://k8s.sagemath.org|k8s.sagemath.org]].

=== Git ===

If you will be doing Sage development, you need to set up a terminal that knows who you are (since we're all using the same user when we log in from the browser).  This way we will be able to share Sage installations on the server.

If you provided your trac username to ORGANIZER, the setup has been done for you.  Otherwise, open up a terminal (`~/Terms/Admin.term` exists for this purpose) and run the script `setup_user` (from anywhere).  This will ask you some questions (name, e-mail, trac account info) and create a terminal for you (`~/Terms/$TRAC_USERNAME.term`).  If you're ever interacting with git, you should use this terminal (or the ssh method described below) so that git knows who you are.

=== Trac Passwords ===

You have the option of storing your trac password (in a plain text file on the server, so don't do so if your trac password is sensitive).  You can control how your trac password is handled by the scripts `set_trac_password` and `unset_trac_password` from your terminal.  If you don't store your trac password in a file, you will be prompted for it when you open your terminal.

=== Editor ===

When you make a git commit, you can specify the commit message on the command line with the `-m` flag.  Otherwise, git will open an editor for you to enter the commit message.  The default editor is `vim`.  If you would rather use a different editor (such as `emacs`), you can set your editor by running the `set_editor` script in your terminal.

=== SSH ===

==== SSHing into the project ====

Instead of using the browser, you can also SSH into the project and work in a terminal on your laptop.

Once you add the public key ''from your laptop'' (generated by `ssh-keygen` and then copied from `~/.ssh/id_rsa.pub` for example) to `~/authorized_keys` ''in the browser'', you will be able to SSH into the project using the following command.

{{{ssh XXX@k8s-ssh.sagemath.org -p 2222}}}

At the beginning of your key in `~/authorized_keys` on the server you should add `command=".init_user roed" ` for example.  You can look at the other keys there for examples.

==== Setting up SSH keys for trac ====

If you want to be able to push changes to trac, you need to upload your key from the k8s server to [[https://trac.sagemath.org/prefs/sshkeys|trac]].  You can find your ssh key by running `show_ssh_key` in your terminal.

=== Sage installations ===

If you provided your trac username to ORGANIZER, you should have a Sage install in `~/Src`.  If not, you can create a new Sage installation for yourself by running
{{{
new_sage
}}}
at your command prompt, or `new_sage $YOUR_TRAC_USERNAME` at any prompt (replacing `$YOUR_TRAC_USERNAME` with your trac username.  Note that this will take some time, since it must build Sage (though the build runs in parallel and doesn't need to build spkgs).

The setup described above also means that the `sage` command in your terminal will be aliased to your copy of Sage.

=== Building and Large output ===

Avoid sending huge amounts of output in a terminal, as this slows the whole project down for everybody (proper output truncation isn’t sufficiently implemented).  Here are some options to avoid this.

1. When building Sage, you can do
{{{
./sage -b > output 2>&1
}}}
rather than just sending a large amount of output to your terminal.  You can check on output by typing
{{{
tail output
}}}

2. If you know tmux, do control+b, then c to make a new session, and leave the large-output session in a different session.  You can switch back and forth with control+b then n.

3. If you've set up your terminal as described above, then
{{{
make build
}}}
in your sage folder will do the redirection for you, as well as automatically use many threads (so that the build goes much faster).
```

## Notes

 * You should collect trac usernames, full names and e-mails from participants in advance.  You may also want to give them the option to provide trac passwords, preferred editors, or ssh-keys for their laptops.

 * You may want to wait to run `new_sage` until fairly soon before the conference, so that the `sage-latest.tar` can be as recent as possible.

 * There is some setup which may need to be done on the `k8s` server if the docker image is restarted.  This may include
```
locale-gen
apt-get install ccache
apt-get install man-db
apt-get install nano
```
You will need admin access to `k8s-ssh` to do so; contact David or William for assistance.

## Todo

 * There's an attempt to write a jupyter kernel in `setup_user`, based on https://github.com/sagemathinc/cocalc/issues/2201.  It doesn't seem to work so it's currently disabled, but it would be great to make it functional.
 * It should be possible to upload ssh keys to trac using `xml-rpc`, eliminating this step for users.