
This image is used to build the 'gnucash-devkit' projects.  This image contains all the necessary
 build tools such as cmake and make and g++ and other libraries.

Upon invocation (aka; run) will place the user in their current folder in a docker
 environment ready to run any of the build-tools.

Here is an example run-script;

    docker run                             \  # docker run
      -it                                  \  # open a terminal
      --rm                                 \  # delete the container after we're done
      --privileged                         \  # might be required to access network devices
      --net host                           \  # grant network access
      -u $(id -u ${USER}):$(id -g ${USER}) \  # fix the user-id and group-id
      -v /etc/passwd:/etc/passwd           \  # hook so name will display correctly
      -v /etc/group:/etc/group             \  # hook so group is available
      -v /home:/home                       \  # map to localhome
      -w ${PWD}                            \  # work in current directory
      lsus1:5000/gnucash-devkit               # the image name to run

Options Details;

'docker run'
This runs the docker image specified by the 'lsus1:5000/gnucash-devkit' on the command line.

'-it'
This causes the console to be automatically connected 'inside' the container, running
 whatever program is running.  If the container had been something like an apache
 web server (httpd-alpine) then using the -it parameter causes the console to immediately
 open on the apache running binary.  Hitting Ctrl-C stops the running program like it
 would in any typical bash program, and stops the running container (since the running
 program inside the container stops, the container itself also stops).  This leaves the
 container still available but not running.  It's possible to dig in to the container to
 remove any content that was generated inside the container, but for all intents and
 purposes, the container is done, but not deleted.

'--rm'
This deletes the container after it is stopped.  This can be important on containers
 that absolutely should not persist after they have executed, but then there are instances
 where the container should not be deleted.  In the case of this build-tools image,
 we don't want anything from inside the container, we just want it to execute in our
 working directory.  After the container is done, we can toss it as everything it worked
 on is still in our local folders.

'--privileged'
This opens the local hardware to the container completely.  This is important for some
 instances of needing access to hardware resources without restriction.  This is also a
 security risk, so it is generally not used unless absolutely necessary (and we know
 where the docker container came from and can trust it completely).

'--net host'
This allows the container to use the networking functions from the host PC.

'-u $(id -u ${USER}):$(id -g ${USER})'
This forwards the user and group information in to the running container.  The trick here
 is to fool the container to think it is running under a specific user and group.  Since
 the container is going to be writing to our local folders in our project directory, we
 need the user and group that is going to be doing that writing to match our actual user
 and group, otherwise any files written to our local folders are written as the user 'root'
 and after the container is finished, we won't be able to use any of those files.

'-v /etc/passwd:/etc/passwd'
'-v /etc/group:/etc/group'
These two options map our local 'passwd' and 'group' files in to the container.  When we
 specify the user and group (above) we cause the container to be running with a user id
 and group id that it knows nothing about.  It causes the container to not be able to
 properly display the user name on the path component, and includes warnings about not
 knowing which group it is a part of.  These are mostly cosmetic complaints, but by
 mapping these two files in to the running container, it can better display who we are.

'-v /home:/home'
This maps the host PC 'home' directory in to the container.  What this does is set up an
 identical path through the home directory in to our working directory.  As soon as we run
 the container we are able to move around inside it as if we were working on the host PC
 directly.  This makes the build-tools then seem like they are installed natively on the
 PC rather than running from a container.

'w ${PWD}'
This sets the 'working' directory to be the same as the path we are in when we launched
 the container.  It makes it seem like, when we launch the container, nothing really changes
 maybe except the apearance of the command prompt.  It's like we are able to install and run
 all our build-tools with a single command.

'lsus1:5000/gnucash-devkit'
This is the name of the actual image that we want to pull from.


Runtime Details;

A couple of tricks are used to cause the running container to appear as though the user
 is simply still logged in to their local console.  They are not logged in to their local
 console, but it's not easy to tell by looking at the command prompt.

Fistly, the -u (user id) and -g (group id) is provided when launched from the command
 line.  This changes the actual user-id and group-id inside the running container.  However,
 this then creates an issue whereby the user-id is set, but there's not user-name to match,
 so the running container prompt looks wrong.  This is fixed by mapping the local 'passwd'
 and 'group' files in to the running container.  Finally, the bash prompt is modified
 on the local user to include a few extra attributes to help indicate that the user is
 inside a container.  This is done by testing for a '.containername' file that was built-in
 to the image.

   75 if test -f /.dockerenv; then
   76   PS1="($(cat /.containername))-> $PS1"
   77 fi

If the 'dockerenv' file exists, then the command prompt is changed to show the containername.

Since the container is going to be mapped to the local /home folders, then when the container
 starts up and opens the bash prompt, it is going to be reading the users '.bashrc' file, and
 processing commands from it.  Therefore, the codes above need to be inserted in to the
 local users .bashrc file.  This way, when the .bashrc file is processed by the container,
 it will hit the 'test' line and detect that it is running within the container, and will
 pick-up this additional prompt information.


