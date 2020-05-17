/// Represents the CPU-Values from the Glances-API.
class CPU {
    /// The ID for the database.
    int id;

    /// The ID from the profile/server which this CPU-Values are related to.
    int profileId;

    /// The timestamp for the database.
    DateTime timeStamp;

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
    int ctxSwitches;

    /// Number of interrupts per second
    int interrupts;

    /// Number of software interrupts per second. Always set to 0 on Windows and SunOS.
    int softwareInterrupts;

    /// Number of system calls per second. Do not displayed on Linux (always 0).
    int systemCalls;

    /// Time passed by since last update.
    double timeSinceUpdate;

    /// Number of available CPU-Cores.
    int cpuCore;

    /// Constructor for JSON-Decoding.
    CPU(double total, double user, double system, double idle, double nice, double ioWait, double irq, double softIrq, double steal, double guest, double guestNice, int ctxSwitches, int interrupts, int softInterrupts, int sysCalls, double timeSinceUpdate, int cpuCore) {
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

    /// For deserialization of JSON and conversion to CPU-Object.
    factory CPU.fromJson(Map json) {
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
            json['ctx_switches'] as int,
            json['interrupts'] as int,
            json['soft_interrupts'] as int,
            json['syscalls'] as int,
            json['time_since_update'] as double,
            json['cpucore'] as int
        );
    }

    Map<String, dynamic> toMap() {
        return {
            'id' : this.id,
            'profileId' : this.profileId,
            'timeStamp' : this.timeStamp,
            'total' : this.totalLoad,
            'user' : this.user,
            'system' : this.system,
            'idle' : this.idle,
            'nice' : this.nice,
            'guestNice' : this.guestNice,
            'ioWait' : this.ioWait,
            'interruptRequest' : this.interruptRequest,
            'softInterruptRequest' : this.softInterruptRequest,
            'steal' : this.steal,
            'guest' : this.guest,
            'ctxSwitches' : this.ctxSwitches,
            'interrupts' : this.interrupts,
            'softwareInterrupts' : this.softwareInterrupts,
            'systemCalls' : this.systemCalls,
            'timeSinceUpdate' : this.timeSinceUpdate,
            'cpuCore' : this.cpuCore
        };
    }
}