# sagedays
Tools for running a Sage Days workshop on CoCalc

To install, do the following:

 * Create a new project, either on the public CoCalc instances or on another server running CoCalc
 * Open the project, and in the `terminal command` line run `git clone https://github.com/roed314/sagedays.git .sagedays`
 * In the same command line, run `mv .sagedays/* .sagedays/.sd.setup .`
 * Open up the terminal `Terms/Admin.term` and run `./.sd.setup`

Installation is complete!  You can create users by running `setup_user` in any terminal, and add Sage installs by running `new_sage $USERNAME1 $USERNAME2 ...`.
