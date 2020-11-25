/// Represents the Memory-Values (RAM) from the Glances-API.
class Memory {
  /// Constructor for Memory-Object.
  Memory(int total, int available, double usagePercent, int used, int free,
      int active, int inactive, int buffers, int cached, int shared) {
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

  /// Total physical memory installed.
  int total;

  /// the actual amount of available memory that can be given instantly to processes that request
  /// more memory in bytes; this is calculated by summing different memory values depending on the platform
  /// (e.g. free + buffers + cached on Linux) and it is supposed to be used to monitor actual memory usage in a cross platform fashion.
  int available;

  /// The percentage usage calculated as (total-available)/total*100.
  double usagePercent;

  /// Memory used, calculated differently depending on the platform and designed for informational purposes only.
  int used;

  /// Memory not being used at all (zeroed) that is readily available; note that this doesn’t reflect the actual memory available (use ‘available’ instead).
  int free;

  /// UNIX: Memory currently in use or very recently used, and so it is in RAM.
  int active;

  /// UNIX: Memory that is marked as not used.
  int inactive;

  /// Linux, BSD: Cache for things like file system metadata.
  int buffers;

  /// Linux, BSD: Cache for various things.
  int cached;

  /// BSD: Memory that may be simultaneously accessed by multiple processes.
  int shared;

  /// For deserialization of JSON and conversion to Memory-Object.
  factory Memory.fromJson(dynamic json) {
    return Memory(
        json['total'] as int,
        json['available'] as int,
        double.parse(json['percent'].toString()),
        json['used'] as int,
        json['free'] as int,
        json['active'] as int,
        json['inactive'] as int,
        json['buffers'] as int,
        json['cached'] as int,
        json['shared'] as int);
  }
}
