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

  double guestNice;

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

  /// Constructor for JSON-Decoding.
  CPU(double total, double user, double system, double idle, double nice, double ioWait, double irq, double softIrq, double steal, double guest, double guestNice, double ctxSwitches, double interrupts, double softInterrupts, double sysCalls, double timeSinceUpdate, int cpuCore) {
    this.totalLoad = total;
    this.user = user;
    this.system = system;
    this.idle = idle;
    this.nice = nice;
    this.ioWait = ioWait;
    this.interruptRequest = irq;
    this.softInterruptRequest = softIrq;
    this.steal = steal;
    this.guest = guest;
    this.guestNice = guestNice;
    this.ctxSwitches = ctxSwitches;
    this.interrupts = interrupts;
    this.softwareInterrupts = softInterrupts;
    this.systemCalls = sysCalls;
    this.timeSinceUpdate = timeSinceUpdate;
    this.cpuCore = cpuCore;
  }

  factory CPU.fromJson(dynamic json) {
    return CPU(
        json['total'] as double,
        json['user'] as double,
        json['system'] as double,
        json['idle'] as double,
        json['nice'] as double,
        json['iowait'] as double,
        json['irq'] as double,
        json['softirq'] as double,
        json['steal'] as double,
        json['guest'] as double,
        json['guest_nice'] as double,
        json['ctx_switches'] as double,
        json['interrupts'] as double,
        json['soft_interrupts'] as double,
        json['syscalls'] as double,
        json['time_since_update'] as double,
        json['cpucore'] as int
    );
  }
}