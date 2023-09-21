import * as z from 'npm:zod@3.22.2'

/**
       /proc/pid/stat
              Status information about the process.  This is used by
              ps(1).  It is defined in the kernel source file
              fs/proc/array.c.

              The fields, in order, with their proper scanf(3) format
              specifiers, are listed below.  Whether or not certain of
              these fields display valid information is governed by a
              ptrace access mode PTRACE_MODE_READ_FSCREDS |
              PTRACE_MODE_NOAUDIT check (refer to ptrace(2)).  If the
              check denies access, then the field value is displayed as
              0.  The affected fields are indicated with the marking
              [PT].
*/


const StatsInputFields = z.object({
  /**
       The process ID.
  */
    pid: z.coerce.number(), //  %d
  /**
       The filename of the executable, in parentheses.
       Strings longer than TASK_COMM_LEN (16) characters
       (including the terminating null byte) are silently
       truncated.  This is visible whether or not the
       executable is swapped out.
  */
    comm: z.string(), //  %s
  /**
       One of the following characters, indicating process
       state:

       R      Running

       S      Sleeping in an interruptible wait

       D      Waiting in uninterruptible disk sleep

       Z      Zombie

       T      Stopped (on a signal) or (before Linux
              2.6.33) trace stopped

       t      Tracing stop (Linux 2.6.33 onward)

       W      Paging (only before Linux 2.6.0)

       X      Dead (from Linux 2.6.0 onward)

       x      Dead (Linux 2.6.33 to 3.13 only)

       K      Wakekill (Linux 2.6.33 to 3.13 only)

       W      Waking (Linux 2.6.33 to 3.13 only)

       P      Parked (Linux 3.9 to 3.13 only)

       I      Idle (Linux 4.14 onward)

  */
    state: z.string(), // %c
  /**
       The PID of the parent of this process.

  */
    ppid: z.coerce.number(), // %d
  /**
       The process group ID of the process.

  */
    pgrp: z.coerce.number(), // %d
  /**
       The session ID of the process.

  */
    session: z.coerce.number(), // %d
  /**
       The controlling terminal of the process.  (The
       minor device number is contained in the combination
       of bits 31 to 20 and 7 to 0; the major device
       number is in bits 15 to 8.)

  */
    tty_nr: z.coerce.number(), // %d
  /**
       The ID of the foreground process group of the
       controlling terminal of the process.

  */
    tpgid: z.coerce.number(), // %d
  /**
       The kernel flags word of the process.  For bit
       meanings, see the PF_* defines in the Linux kernel
       source file include/linux/sched.h.  Details depend
       on the kernel version.

       The format for this field was %lu before Linux 2.6.

  */
    flags: z.coerce.number(), //  %u
  /**
       The number of minor faults the process has made
       which have not required loading a memory page from
       disk.

  */
     minflt: z.coerce.number(), // %lu
  /**
       The number of minor faults that the process's
       waited-for children have made.

  */
     cminflt: z.coerce.number(), // %lu
  /**
       The number of major faults the process has made
       which have required loading a memory page from
       disk.

  */
     majflt: z.coerce.number(), // %lu
  /**
       The number of major faults that the process's
       waited-for children have made.

  */
     cmajflt: z.coerce.number(), // %lu
  /**
       Amount of time that this process has been scheduled
       in user mode, measured in clock ticks (divide by
       sysconf(_SC_CLK_TCK)).  This includes guest time,
       guest_time (time spent running a virtual CPU, see
       below), so that applications that are not aware of
       the guest time field do not lose that time from
       their calculations.

  */
     utime: z.coerce.number(), // %lu
  /**
       Amount of time that this process has been scheduled
       in kernel mode, measured in clock ticks (divide by
       sysconf(_SC_CLK_TCK)).

  */
     stime: z.coerce.number(), // %lu
  /**
       Amount of time that this process's waited-for
       children have been scheduled in user mode, measured
       in clock ticks (divide by sysconf(_SC_CLK_TCK)).
       (See also times(2).)  This includes guest time,
       cguest_time (time spent running a virtual CPU, see
       below).

  */
     cutime: z.coerce.number(), // %ld
  /**
       Amount of time that this process's waited-for
       children have been scheduled in kernel mode,
       measured in clock ticks (divide by
       sysconf(_SC_CLK_TCK)).

  */
     cstime: z.coerce.number(), // %ld
  /**
       (Explanation for Linux 2.6) For processes running a
       real-time scheduling policy (policy below; see
       sched_setscheduler(2)), this is the negated
       scheduling priority, minus one; that is, a number
       in the range -2 to -100, corresponding to real-time
       priorities 1 to 99.  For processes running under a
       non-real-time scheduling policy, this is the raw
       nice value (setpriority(2)) as represented in the
       kernel.  The kernel stores nice values as numbers
       in the range 0 (high) to 39 (low), corresponding to
       the user-visible nice range of -20 to 19.

       Before Linux 2.6, this was a scaled value based on
       the scheduler weighting given to this process.

  */
     priority: z.coerce.number(), // %ld
  /**
       The nice value (see setpriority(2)), a value in the
       range 19 (low priority) to -20 (high priority).

  */
     nice: z.coerce.number(), // %ld
  /**
       Number of threads in this process (since Linux
       2.6).  Before Linux 2.6, this field was hard coded
       to 0 as a placeholder for an earlier removed field.

  */
     num_threads: z.coerce.number(), // %ld
  /**
       The time in jiffies before the next SIGALRM is sent
       to the process due to an interval timer.  Since
       Linux 2.6.17, this field is no longer maintained,
       and is hard coded as 0.

  */
     itrealvalue: z.coerce.number(), // %ld
  /**
       The time the process started after system boot.
       Before Linux 2.6, this value was expressed in
       jiffies.  Since Linux 2.6, the value is expressed
       in clock ticks (divide by sysconf(_SC_CLK_TCK)).

       The format for this field was %lu before Linux 2.6.

  */
     starttime: z.coerce.number(), // %llu
  /**
       Virtual memory size in bytes.

  */
     vsize: z.coerce.number(), // %lu
  /**
       Resident Set Size: number of pages the process has
       in real memory.  This is just the pages which count
       toward text, data, or stack space.  This does not
       include pages which have not been demand-loaded in,
       or which are swapped out.  This value is
       inaccurate; see /proc/pid/statm below.

  */
     rss: z.coerce.number(), // %ld
  /**
       Current soft limit in bytes on the rss of the
       process; see the description of RLIMIT_RSS in
       getrlimit(2).

  */
     rsslim: z.coerce.number(), // %lu
  /**
       The address above which program text can run.

  */
     startcode: z.coerce.number(), // %lu  [PT]
  /**
       The address below which program text can run.

  */
     endcode: z.coerce.number(), // %lu  [PT]
  /**
       The address of the start (i.e., bottom) of the
       stack.

  */
     startstack: z.coerce.number(), // %lu  [PT]
  /**
       The current value of ESP (stack pointer), as found
       in the kernel stack page for the process.

  */
     kstkesp: z.coerce.number(), // %lu  [PT]
  /**
       The current EIP (instruction pointer).

  */
     kstkeip: z.coerce.number(), // %lu  [PT]
  /**
       The bitmap of pending signals, displayed as a
       decimal number.  Obsolete, because it does not
       provide information on real-time signals; use
       /proc/pid/status instead.

  */
     signal: z.coerce.number(), // %lu
  /**
       The bitmap of blocked signals, displayed as a
       decimal number.  Obsolete, because it does not
       provide information on real-time signals; use
       /proc/pid/status instead.

  */
     blocked: z.coerce.number(), // %lu
  /**
       The bitmap of ignored signals, displayed as a
       decimal number.  Obsolete, because it does not
       provide information on real-time signals; use
       /proc/pid/status instead.

  */
     sigignore: z.coerce.number(), // %lu
  /**
       The bitmap of caught signals, displayed as a
       decimal number.  Obsolete, because it does not
       provide information on real-time signals; use
       /proc/pid/status instead.

  */
     sigcatch: z.coerce.number(), // %lu
  /**
       This is the "channel" in which the process is
       waiting.  It is the address of a location in the
       kernel where the process is sleeping.  The
       corresponding symbolic name can be found in
       /proc/pid/wchan.

  */
     wchan: z.coerce.number(), // %lu  [PT]
  /**
       Number of pages swapped (not maintained).

  */
     nswap: z.coerce.number(), // %lu
  /**
       Cumulative nswap for child processes (not
       maintained).

  */
     cnswap: z.coerce.number(), // %lu
  /**
       Signal to be sent to parent when we die.

  */
     exit_signal: z.coerce.number(), // %d  (since Linux 2.1.22)
  /**
       CPU number last executed on.

  */
     processor: z.coerce.number(), // %d  (since Linux 2.2.8)
  /**
       Real-time scheduling priority, a number in the
       range 1 to 99 for processes scheduled under a real-
       time policy, or 0, for non-real-time processes (see
       sched_setscheduler(2)).

  */
     rt_priority: z.coerce.number(), // %u  (since Linux 2.5.19)
  /**
       Scheduling policy (see sched_setscheduler(2)).
       Decode using the SCHED_* constants in
       linux/sched.h.

       The format for this field wa: z.coerce.number(), // %lu before Linux
       2.6.22.

  */
     policy: z.coerce.number(), // %u  (since Linux 2.5.19)
  /**
       Aggregated block I/O delays, measured in clock
       ticks (centiseconds).

  */
     delayacct_blkio_ticks: z.coerce.number(), // %llu  (since Linux 2.6.18)
  /**
       Guest time of the process (time spent running a
       virtual CPU for a guest operating system), measured
       in clock ticks (divide by sysconf(_SC_CLK_TCK)).

  */
     guest_time: z.coerce.number(), // %lu  (since Linux 2.6.24)
  /**
       Guest time of the process's children, measured in
       clock ticks (divide by sysconf(_SC_CLK_TCK)).

  */
     cguest_time: z.coerce.number(), // %ld  (since Linux 2.6.24)
  /**
       Address above which program initialized and
       uninitialized (BSS) data are placed.

  */
     start_data: z.coerce.number(), // %lu  (since Linux 3.3)  [PT]
  /**
       Address below which program initialized and
       uninitialized (BSS) data are placed.

  */
     end_data: z.coerce.number(), // %lu  (since Linux 3.3)  [PT]
  /**
       Address above which program heap can be expanded
       with brk(2).

  */
     start_brk: z.coerce.number(), // %lu  (since Linux 3.3)  [PT]
  /**
       Address above which program command-line arguments
       (argv) are placed.

  */
     arg_start: z.coerce.number(), // %lu  (since Linux 3.5)  [PT]
  /**
       Address below program command-line arguments (argv)
       are placed.

  */
     arg_end: z.coerce.number(), // %lu  (since Linux 3.5)  [PT]
  /**
       Address above which program environment is placed.

  */
     env_start: z.coerce.number(), // %lu  (since Linux 3.5)  [PT]
  /**
       Address below which program environment is placed.

  */
     env_end: z.coerce.number(), // %lu  (since Linux 3.5)  [PT]
  /**
       The thread's exit status in the form reported by
       waitpid(2).
  */
     exit_code: z.coerce.number(), // %d  (since Linux 3.5)  [PT]
})

const stat_keys = Object.keys(StatsInputFields.shape)

class StatsInput {
  static parse(stat: string) {
    const stats = stat.split(' ')
    const stats_object: Record<string, string> = {}
    for (const [index, stat_key] of stat_keys.entries()) {
      stats_object[stat_key] = stats[index]
    }
    return StatsInputFields.parse(stats_object)
  }
}

type CpuStats = z.infer<typeof StatsInputFields>


export { StatsInput, type CpuStats }
