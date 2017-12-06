## cpd - The copy daemon

_cpd_ is a pure _bash_ script without any special requirements except a _*NIX Box_ and a not to old _bash_ version.

The purpose is collect copy jobs and start them only if the target drive is not busy by an other copy job under _cpd_ supervision.

### Project Status is pre release

### Usage

    cpd [option>...] <command> [<argument>...]
    cpd [option>...] newjob <dest-dir> <source>...
    cpd [option>...] newjob <dest-dir>                   # Read list of sources from stdin
    cpd [option>...] newjob -f <file> <dest-dir>

### Options are:

    -c <cols>                Force output to cut at <cols>, 0 or negative=no cut
    -f <file>                Read list of source files from <file>
    -m                       Merge all files in <dest-dir>. Ignored if -o is given
    -o <cp-opt>              Add <cp-opt> to the called cp command. Disables -r/-m if given
    -p <user-prio>           Enqueue job with modified default priority. PRIO=6 minus <user-prio>
    -r                       Copy recursive. Ignored if -o is given
    -i <idle-time>           Daemon stand by time in seconds, default=600, unlimited=-1
    -s                       Run a simulation, copy nothing
    -a                       Auto start the daemon if not already running

### Commands are:

    h, help [c]              Show this help or when c=l License, c=s Source of cpd
    H                        Show more help
       newjob <arguments>    Enqueue a new job with arguments as shown above
       start                 Start the daemon and job processing
    X, exit                  Terminate the daemon and job processing
    P, process               Process jobs in foreground or trigger daemon to continue
    K, kill <job>...         Kill a running or cancel a pending job
    p, prio <prio> <job>...  Change job PRIO to <prio> or 'PRIO=PRIO minus <prio>' if +-<prio>
    r, resume <job>...       Resume jobs
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

    watch -n1 cpd w

or

    watch -n1 cpd w s

### Simulation Mode

Instead of calling _cp_ with all job parameter, there will only start a _sleep/forced-error job_ with a crude chosen time of a few seconds.

### Running Test

    $ ./runTest
    Start with clean tmp dir

    Run: ./cpd w
    ID PRIO STATUS   SIZE  DRIVE            TARGET                FILES
      4   3  pending    7K  luks-as2dws34xy  /media/luks/foo       data1
      5   3  pending    9M  luks-as2dws34xy  /media/luks/foo       secret stuff important data
      6   3  pending   34K  /dev/sdc         /media/c/foo          cpd cpd1
      3   5  pending   21K  /dev/sdd         /media/d/foo          /media/data/raz /media/data/baz
      1   6  pending   705  /dev/sda         /media/a/foo          /media/data/foo
      2   7  pending    7K  /dev/sda         /media/a/foo          /media/data/bar

    Run: ./cpd -s P
    Running a simulation, nothing will copied
    Start   [  4] [luks-as2dws34xy]      /media/luks/foo <- data1
    Start   [  6] [/dev/sdc       ]         /media/c/foo <- cpd cpd1
    Start   [  3] [/dev/sdd       ]         /media/d/foo <- /media/data/raz /media/data/baz
    Start   [  1] [/dev/sda       ]         /media/a/foo <- /media/data/foo
    Stop    [  4] [luks-as2dws34xy]      /media/luks/foo <- data1
    Start   [  5] [luks-as2dws34xy]      /media/luks/foo <- secret stuff important data
    Killed  [  5] [luks-as2dws34xy]      /media/luks/foo <- secret stuff important data
    Killed  [  6] [/dev/sdc       ]         /media/c/foo <- cpd cpd1
    Resume  [  4] [luks-as2dws34xy]      /media/luks/foo <- data1
    Done    [  1] [/dev/sda       ]         /media/a/foo <- /media/data/foo
    Start   [  2] [/dev/sda       ]         /media/a/foo <- /media/data/bar
    Done    [  4] [luks-as2dws34xy]      /media/luks/foo <- data1
    Done    [  2] [/dev/sda       ]         /media/a/foo <- /media/data/bar
    Done    [  3] [/dev/sdd       ]         /media/d/foo <- /media/data/raz /media/data/baz
    All done

    Run: ./cpd w e
    >>>>> Error log of job 6
    What ever was wrong

**Note:** If there are errors to read, they are features, but you may find true bugs

### Install

#### From Source

Copy _cpd_ somewhere to your $PATH and create a symlink there at your taste, e.g.

    ln -s cpd cpc

that's all.

### TODO

  - Improve detection of true target drives
  - BUG: Does not handle filenames with newline
  - Modify command _show_ to view a specific log file
  - Modify command _show w_ to take arguments to choose data to display
  - Solution to #6
  - Enhance this list

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
