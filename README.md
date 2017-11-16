## cpd - The copy daemon

_cpd_ is a pure _bash_ script without any special requirements except a _*NIX Box_ and a not to old _bash_ version.

The purpose is collect copy jobs and start them only if the target drive is not busy by an other copy job under _cpd_ supervision.

### Project Status

It's pre release and by default only running in a simulation mode. Instead of calling _cp_ with all job parameter, there will only start a _sleep-job_ with a randomly chosen time of a view seconds.

To change this edit in the source the setting of "simulationMode" from "1" to "0".

### Usage

    cpd <dest-dir> <source>...
    cpd <command> [<argument>...]

### Commands are:

    -C <job-id>        Cancel a pending or kill a running job
    -D [<action>]      Print status and start/stop the daemon or job processing
                      <action> can be +|-|start|stop
    -h [c]             Show this help or when c=l License, c=s Source of cpd
    -H                 Show more help
    -l [c]             List jobs, c=i by ID
    -P                 Process jobs or trigger daemon to continue
    -p <job-id> <prio> Change job priority 3-8
    -r <job-id>        Resume a job
    -s <job-id>        Stop a job
    -T                 Tidy up all job data

### Workflow

Enque a couple of jobs

    cpd /media/1a/foo /media/1b/foo
    cpd /media/2a/bar /media/2b/bar
    cpd /media/2a/qux /media/2b/qux
    ...

Process the jobs in the foreground...

    cpd -P

...or start the daemon...

    cpd -D+

...and take a look how it is going

    watch -n1 cpd -l

### Running Test

    $ ./runTest
    Start with clean tmp dir

    Run: cpd -l
    ID PRIO STATUS   DONE  DRIVE            TARGET                ARGUMENTS
      4   3  pending     ?  luks-as2dws34xy  '/media/luks/foo'     'data1'
      5   3  pending     ?  luks-as2dws34xy  '/media/luks/foo'     'secret stuf
      6   3  pending     ?  /dev/sdc         '/media/c/foo'        'cpd' 'cpd1'
      3   5  pending     ?  /dev/sdd         '/media/d/foo'        '/media/data
      1   6  pending     ?  /dev/sda         '/media/a/foo'        '/media/data
      2   7  pending     ?  /dev/sda         '/media/a/foo'        '/media/data

    Run: cpd -P
    Start   [  4] [luks-as2dws34xy]    '/media/luks/foo' <- 'data1'
    Start   [  6] [/dev/sdc       ]       '/media/c/foo' <- 'cpd' 'cpd1'
    ERROR   [  6] [/dev/sdc       ]       '/media/c/foo' <- 'cpd' 'cpd1'
    Start   [  3] [/dev/sdd       ]       '/media/d/foo' <- '/media/data/raz' '
    Start   [  1] [/dev/sda       ]       '/media/a/foo' <- '/media/data/foo'
    Cancel  [  5] [luks-as2dws34xy]    '/media/luks/foo' <- 'secret stuff' 'imp
    Stop    [  4] [luks-as2dws34xy]    '/media/luks/foo' <- 'data1'
    Done    [  3] [/dev/sdd       ]       '/media/d/foo' <- '/media/data/raz' '
    Resume  [  4] [luks-as2dws34xy]    '/media/luks/foo' <- 'data1'
    Done    [  4] [luks-as2dws34xy]    '/media/luks/foo' <- 'data1'
    Done    [  1] [/dev/sda       ]       '/media/a/foo' <- '/media/data/foo'
    Start   [  2] [/dev/sda       ]       '/media/a/foo' <- '/media/data/bar'
    Done    [  2] [/dev/sda       ]       '/media/a/foo' <- '/media/data/bar'
    All done

**Note:** These errors are features, but you may find true bugs

### Install

#### From Source

Copy _cpd_ somewhere to your $PATH, that's all.

### TODO

  - Respect the home dir of the jobs
  - Add command to view the various log files
  - Progress info about each running job
  - Full _cp_ support
  - Improve detection of true target drives
  - Enhance this list

### Credits

_cpd_ is inspired by _Ambrevar_ who was
[looking for a tool similar to this](https://bbs.archlinux.org/viewtopic.php?id=228701)

All contributors of stackexchange.com, bash-hackers.org, dict.cc and many more.

### License

GNU General Public License (GPL), Version 2.0
