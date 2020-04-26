class CPU {
  /// Percent of total CPU-Load.
  double totalLoad;

  /// Percent time spent in user space.
  double user;

  /// Percent time spent in kernel space
  double system;

  /// Percent of CPU used by any program.
  double idle;

  /// Percent time occupied by user level processes with a positive nice value
  double nice;

  /// Linux: Percent time spent by the CPU waiting for I/O operations to complete.
  double ioWait;

  /// Percent time spent servicing/handling hardware interrupts
  double interruptRequest;

  /// Percent time spent servicing/handling software interrupts
  double softInterruptRequest;

  /// Percentage of time a virtual CPU waits for a real CPU while the hypervisor is servicing another virtual processor
  double steal;

  double guest;

  /// Number of context switches (voluntary + involuntary) per second
  double ctxSwitches;

  /// Number of interrupts per second
  double interrupts;

  /// Number of software interrupts per second. Always set to 0 on Windows and SunOS.
  double softwareInterrupts;

  /// Number of system calls per second. Do not displayed on Linux (always 0).
  double systemCalls;

  /// Time passed by since last update.
  double timeSinceUpdate;

  /// Number of available CPU-Cores.
  int cpuCore;
}