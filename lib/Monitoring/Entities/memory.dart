class Memory {
  /// Total physical memory installed.
  double total;

  /// the actual amount of available memory that can be given instantly to processes that request
  /// more memory in bytes; this is calculated by summing different memory values depending on the platform
  /// (e.g. free + buffers + cached on Linux) and it is supposed to be used to monitor actual memory usage in a cross platform fashion.
  double available;

  /// The percentage usage calculated as (total-available)/total*100.
  double usagePercent;

  /// Memory used, calculated differently depending on the platform and designed for informational purposes only.
  double used;

  /// Memory not being used at all (zeroed) that is readily available; note that this doesn’t reflect the actual memory available (use ‘available’ instead).
  double free;

  /// UNIX: Memory currently in use or very recently used, and so it is in RAM.
  double active;

  /// UNIX: Memory that is marked as not used.
  double inactive;

  /// Linux, BSD: Cache for things like file system metadata.
  double buffers;

  /// Linux, BSD: Cache for various things.
  double cached;

  /// BSD: Memory that may be simultaneously accessed by multiple processes.
  double shared;

  /// Constructor for Memory-Object.
  Memory(double total, double available, double usagePercent, double used, double free, double active, double inactive, double buffers, double cached, double shared) {
    this.total = total;
    this.available = available;
    this.usagePercent = usagePercent;
    this.used = used;
    this.free = free;
    this.active = active;
    this.inactive = inactive;
    this.buffers = buffers;
    this.cached = cached;
    this.shared = shared;
  }

  /// For deserialization of JSON and conversion to Memory-Object.
  factory Memory.fromJson(dynamic json) {
    return Memory(
        json['total'] as double,
        json['available'] as double,
        json['percent'] as double,
        json['used'] as double,
        json['free'] as double,
        json['active'] as double,
        json['inactive'] as double,
        json['buffers'] as double,
        json['cached'] as double,
        json['shared'] as double
    );
  }
}