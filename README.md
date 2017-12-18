## cpd - The copy daemon

_cpd_ is a pure _bash_ script without any special requirements except a
 _*NIX Box_ and a not to old _bash_ version.

Furthermore may it still a little _GNUish_. I can't, and will not, test it with
 other Unices than _ArchLinux_ but patches and bug reports are welcome.

The purpose is collect copy jobs and start them only if the target drive is not
 busy by any other copy job under _cpd_ supervision.

### Last (and very first) version is v0.1 (Dez 2017)

There are things which could be improved, or fixed, but I think it is now almost
 feature complete. So someone would call it a _1.0 RCx_ release.

### Usage

    cpd [option>...] <command> [<argument>...]
    cpd [option>...] newjob <source> <destination>
    cpd [option>...] newjob <source>... <dest-dir>
    cpd [option>...] newjob -t <dest-dir> <source>...
    cpd [option>...] newjob <dest-dir>                   # Read list of sources from stdin
    cpd [option>...] newjob -f <file> <dest-dir>

### Options are:

    -a                       Auto start the daemon if not already running
    -c <cols>                Force output to cut at <cols>, 0 or negative=no cut
    -f <file>                Read list of source files from <file>
    -i <idle-time>           Daemon stand by time in seconds, default=600, unlimited=-1
    -o <cp-opt>              Add <cp-opt> to the called cp command. Disables -r/-m if given
    -p <user-prio>           Enqueue job with modified default priority. PRIO=6 minus <user-prio>
    -s                       Run a simulation, copy nothing
    Only available with GNU copy
    -m                       Merge all files in <dest-dir>. Ignored if -o is given
    -r                       Copy recursive. Ignored if -o is given

### Commands are:

    h, help [c]              Show this help or when c=l License, c=s Source of cpd
    H                        Show more help
       newjob <arguments>    Enqueue a new job with arguments as shown above
       start                 Start the daemon and job processing
    X, exit                  Terminate the daemon and job processing
    P, process               Process jobs in foreground or trigger daemon to continue
    K, kill <job>...         Kill a running or cancel a pending job
    p, prio <prio> <job>...  Change job PRIO to <prio> or 'PRIO=PRIO minus <prio>' if +-<prio>
    r, resume <job>...       Resume stopped jobs or re-enqueue old jobs
    w, show [c]              Show jobs, c=i by ID, c=e errors, c=l job log, c=s daemon status
    s, stop <job>...         Stop jobs
    Y, tidy                  Tidy up all job data

### Workflow

Enqueue a couple of jobs

    cpd newjob /media/a /foo/*
    ...

Assumed you have a symlink _cpc->cpd_

    cpc /media/b /bar/*

Process the jobs in the foreground...

    cpd P

...or start the daemon...

    cpd start

...and take a look how it is going

    watch -n1 cpd wi

or

    watch -n1 cpd w s

### Simulation Mode

Instead of calling _cp_ with all job parameter, there will only start a
 _sleep/forced-error job_ with a crude chosen time of a few seconds.

### Running Test

    $ ./test/simulation
    Prepare test with clean tmp dir

    Run: ./cpd show
    ID STATUS PRIO   PID SIZE DONE DRIVE            TARGET                FILES
      2 pending  4      -  70M   0% /dev/sdb         /media/b/data         data1-50;data7;dat~
      5 pending  4      -  70M   0% /dev/sdc         /media/c/data         data2-50;data7;dat~
      7 pending  5      -  500   0% /dev/sdd         /media/d/notes/       file5-100;file4-10~
      1 pending  6      - 512K   0% /dev/sdb         /media/b/documents/   paper5-100;paper4-~
      3 pending  6      -  32M   0% /dev/sdb         /media/b/mediathek    song5-5;song4-5;so~
      4 pending  6      -  32M   0% /dev/sdc         /media/c/documents/   invoice5-5;invoice~
      6 pending  6      - 315M   0% /dev/sdc         /media/c/mediathek    clip5-50;clip4-50;~

    Run: ./cpd -s process
    Running a simulation, nothing will copied
    Start   [  2] [/dev/sdb       ]        /media/b/data <- data1-50;data7;data6;data5;data4;>
    Start   [  5] [/dev/sdc       ]        /media/c/data <- data2-50;data7;data6;data5;data4;>
    Start   [  7] [/dev/sdd       ]      /media/d/notes/ <- file5-100;file4-100;file3-100;fil>
    * New or changed jobs by user *
    Stop    [  2] [/dev/sdb       ]        /media/b/data <- data1-50;data7;data6;data5;data4;>
    Start   [  1] [/dev/sdb       ]  /media/b/documents/ <- paper5-100;paper4-100;paper3-100;>
    * New or changed jobs by user *
    Done    [  7] [/dev/sdd       ]      /media/d/notes/ <- file5-100;file4-100;file3-100;fil>
    Killed  [  5] [/dev/sdc       ]        /media/c/data <- data2-50;data7;data6;data5;data4;>
    Start   [  4] [/dev/sdc       ]  /media/c/documents/ <- invoice5-5;invoice4-5;invoice3-5;>
    * New or changed jobs by user *
    Done    [  1] [/dev/sdb       ]  /media/b/documents/ <- paper5-100;paper4-100;paper3-100;>
    Resume  [  2] [/dev/sdb       ]        /media/b/data <- data1-50;data7;data6;data5;data4;>
    ERROR   [  2] [/dev/sdb       ]        /media/b/data <- data1-50;data7;data6;data5;data4;>
    Start   [  3] [/dev/sdb       ]   /media/b/mediathek <- song5-5;song4-5;song3-5;song2-5;s>
    Done    [  4] [/dev/sdc       ]  /media/c/documents/ <- invoice5-5;invoice4-5;invoice3-5;>
    Start   [  5] [/dev/sdc       ]        /media/c/data <- data2-50;data7;data6;data5;data4;>
    ERROR   [  5] [/dev/sdc       ]        /media/c/data <- data2-50;data7;data6;data5;data4;>
    Start   [  6] [/dev/sdc       ]   /media/c/mediathek <- clip5-50;clip4-50;clip3-50;clip2->
    Done    [  3] [/dev/sdb       ]   /media/b/mediathek <- song5-5;song4-5;song3-5;song2-5;s>
    Done    [  6] [/dev/sdc       ]   /media/c/mediathek <- clip5-50;clip4-50;clip3-50;clip2->
    All done

    Run: ./cpd show e
    >>>>> Error log of job 2
    What ever was wrong

    >>>>> Error log of job 5
    What ever was wrong

**Note:** If there are errors to read, they are features, but you may find true bugs

### Install

#### From Source

Copy _cpd_ somewhere to your _$PATH_ and create a symlink there at your taste, e.g.

    ln -s cpd cpc

that's all.

### TODO

  - Improve detection of true target drives
  - Review logging stuff, now it looks a little haphazard
  - Modify command _show w_ to take arguments to choose data to display
  - Solution to #6 nice/ionice

### Things they have to wait for a past 1.0 release

  - Change prio of jobs like so: cpc mov job x above/below job y
  or in some other way to have a better solution as right now
  - An option to specify the command to use, e.g: _cpc -B mv foo bar_ to move
  instead of copy the files. (B like binary)

### Credits

_cpd_ is inspired by _Ambrevar_ who was
[looking for a tool](https://bbs.archlinux.org/viewtopic.php?id=228701) similar to this.

All contributors of stackexchange.com, bash-hackers.org, dict.cc and many more.

### License

GNU General Public License (GPL), Version 2.0
